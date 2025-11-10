import 'package:flutter/material.dart';

import '../../models/master/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late List<ProductModel> _productList;
  late TabController _tabController;
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _productList = ProductModel.mockData();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _refreshData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _addNewProduct() {
    _showAddOrEditProductDialog(context, null);
  }

  Future<void> _showAddOrEditProductDialog(
    BuildContext context,
    ProductModel? item,
  ) async {
    final isEditing = item != null;

    final maSanPhamCtrl = TextEditingController(text: item?.maSanPham ?? '');
    final tenSanPhamCtrl = TextEditingController(text: item?.tenSanPham ?? '');
    final nhomSanPhamCtrl = TextEditingController(
      text: item?.nhomSanPham ?? '',
    );
    final trongLuongCtrl = TextEditingController(
      text: item?.trongLuong.toString() ?? '',
    );
    final donViCtrl = TextEditingController(
      text: item?.donViTrongLuong ?? 'kg',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: maSanPhamCtrl,
                decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
              ),
              TextField(
                controller: tenSanPhamCtrl,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: nhomSanPhamCtrl,
                decoration: const InputDecoration(labelText: 'Nhóm sản phẩm'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: trongLuongCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Trọng lượng',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: donViCtrl,
                      decoration: const InputDecoration(labelText: 'Đơn vị'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  final idx = _productList.indexOf(item!);
                  _productList[idx] = item.copyWith(
                    maSanPham: maSanPhamCtrl.text,
                    tenSanPham: tenSanPhamCtrl.text,
                    nhomSanPham: nhomSanPhamCtrl.text,
                    trongLuong:
                        double.tryParse(trongLuongCtrl.text.trim()) ?? 0,
                    donViTrongLuong: donViCtrl.text,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: 'Admin',
                  );
                } else {
                  _productList.add(
                    ProductModel(
                      stt: _productList.length + 1,
                      maSanPham: maSanPhamCtrl.text,
                      tenSanPham: tenSanPhamCtrl.text,
                      nhomSanPham: nhomSanPhamCtrl.text,
                      trongLuong:
                          double.tryParse(trongLuongCtrl.text.trim()) ?? 0,
                      donViTrongLuong: donViCtrl.text,
                      ngayTao: DateTime.now(),
                      nguoiTao: 'Admin',
                      ngayCapNhat: null,
                      nguoiCapNhat: null,
                      soLuongLenhSanXuat: 0,
                    ),
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalWeight = _productList.fold<double>(
      0,
      (sum, item) => sum + item.trongLuong,
    );
    final totalProduct = _productList.length;

    final filteredList = _productList
        .where(
          (p) =>
              p.tenSanPham.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.maSanPham.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách Sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () {},
            tooltip: 'Nhập file',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {},
            tooltip: 'Xuất file',
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _addNewProduct,
            icon: const Icon(Icons.add),
            label: const Text('Thêm sản phẩm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Header thống kê
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryBox('Tổng sản phẩm', '$totalProduct', Colors.blue),
                _buildSummaryBox(
                  'Tổng trọng lượng',
                  '${totalWeight.toStringAsFixed(2)} kg',
                  Colors.green,
                ),
                _buildSummaryBox('Đang hoạt động', '15', Colors.orange),
              ],
            ),
          ),

          // 🔹 Tabs lọc trạng thái
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            tabs: const [
              Tab(text: 'Tất cả sản phẩm'),
              Tab(text: 'Đang sản xuất'),
              Tab(text: 'Hoàn thành'),
            ],
          ),

          // 🔹 Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo mã, tên sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // 🔹 Bảng sản phẩm
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('STT')),
                        DataColumn(label: Text('Mã sản phẩm')),
                        DataColumn(label: Text('Tên sản phẩm')),
                        DataColumn(label: Text('Nhóm')),
                        DataColumn(label: Text('Trọng lượng')),
                        DataColumn(label: Text('Người tạo')),
                        DataColumn(label: Text('Ngày tạo')),
                        DataColumn(label: Text('Trạng thái')),
                        DataColumn(label: Text('')),
                      ],
                      rows: filteredList.map((item) {
                        final isDone = item.stt % 2 == 0;
                        return DataRow(
                          cells: [
                            DataCell(Text(item.stt.toString())),
                            DataCell(Text(item.maSanPham)),
                            DataCell(Text(item.tenSanPham)),
                            DataCell(Text(item.nhomSanPham)),
                            DataCell(
                              Text(
                                '${item.trongLuong} ${item.donViTrongLuong}',
                              ),
                            ),
                            DataCell(Text(item.nguoiTao)),
                            DataCell(
                              Text(
                                '${item.ngayTao.day}/${item.ngayTao.month}/${item.ngayTao.year}',
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isDone ? 'Hoàn thành' : 'Đang SX',
                                  style: TextStyle(
                                    color: isDone
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () =>
                                        _showAddOrEditProductDialog(
                                          context,
                                          item,
                                        ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => setState(
                                      () => _productList.remove(item),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
