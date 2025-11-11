import 'package:flutter/material.dart';
import '../../models/master/product_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<ProductScreen> {
  late List<ProductModel> _products;
  late List<ProductModel> _filteredProducts;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _products = ProductModel.mockData();
    _filteredProducts = List.from(_products);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredProducts = _products.where((p) {
        return p.maSanPham.toLowerCase().contains(query.toLowerCase()) ||
            p.tenSanPham.toLowerCase().contains(query.toLowerCase()) ||
            p.nhomSanPham.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(ProductModel p) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredProducts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  Future<void> _showAddOrEditDialog(
    BuildContext context,
    ProductModel? item,
  ) async {
    final isEditing = item != null;

    final sttCtrl = TextEditingController(
      text: isEditing
          ? item!.stt.toString()
          : (_products.length + 1).toString(),
    );
    final maSPCtrl = TextEditingController(text: item?.maSanPham ?? '');
    final tenSPCtrl = TextEditingController(text: item?.tenSanPham ?? '');
    final nhomSPCtrl = TextEditingController(text: item?.nhomSanPham ?? '');
    final trongLuongCtrl = TextEditingController(
      text: isEditing ? item!.trongLuong.toString() : '',
    );
    final donViCtrl = TextEditingController(
      text: item?.donViTrongLuong ?? 'kg',
    );
    final soLuongLenhCtrl = TextEditingController(
      text: isEditing ? item!.soLuongLenhSanXuat.toString() : '',
    );
    final nguoiTaoCtrl = TextEditingController(text: item?.nguoiTao ?? 'Admin');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: sttCtrl,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'STT'),
                ),
                TextField(
                  controller: maSPCtrl,
                  decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
                ),
                TextField(
                  controller: tenSPCtrl,
                  decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextField(
                  controller: nhomSPCtrl,
                  decoration: const InputDecoration(labelText: 'Nhóm sản phẩm'),
                ),
                TextField(
                  controller: trongLuongCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Trọng lượng (kg)',
                  ),
                ),
                TextField(
                  controller: donViCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị trọng lượng',
                  ),
                ),
                TextField(
                  controller: soLuongLenhCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng lệnh SX',
                  ),
                ),
                TextField(
                  controller: nguoiTaoCtrl,
                  decoration: const InputDecoration(labelText: 'Người tạo'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              final stt = int.tryParse(sttCtrl.text) ?? (_products.length + 1);
              final trongLuong = double.tryParse(trongLuongCtrl.text) ?? 0;
              final soLuongLenh = int.tryParse(soLuongLenhCtrl.text) ?? 0;

              if (maSPCtrl.text.isEmpty ||
                  tenSPCtrl.text.isEmpty ||
                  nhomSPCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin'),
                  ),
                );
                return;
              }

              setState(() {
                if (isEditing) {
                  final index = _products.indexOf(item!);
                  _products[index] = ProductModel(
                    stt: stt,
                    maSanPham: maSPCtrl.text,
                    tenSanPham: tenSPCtrl.text,
                    nhomSanPham: nhomSPCtrl.text,
                    trongLuong: trongLuong,
                    donViTrongLuong: donViCtrl.text,
                    ngayTao: item!.ngayTao,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: nguoiTaoCtrl.text,
                    soLuongLenhSanXuat: soLuongLenh,
                  );
                } else {
                  final newItem = ProductModel(
                    stt: _products.length + 1,
                    maSanPham: maSPCtrl.text,
                    tenSanPham: tenSPCtrl.text,
                    nhomSanPham: nhomSPCtrl.text,
                    trongLuong: trongLuong,
                    donViTrongLuong: donViCtrl.text,
                    ngayTao: DateTime.now(),
                    nguoiTao: nguoiTaoCtrl.text,
                    soLuongLenhSanXuat: soLuongLenh,
                    nguoiCapNhat: nguoiTaoCtrl.text,
                    ngayCapNhat: DateTime.now(),
                  );
                  _products.add(newItem);
                }
                _filterSearch(searchController.text);
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  int get totalProducts => _filteredProducts.length;
  double get totalWeight {
    double total = 0;
    for (var p in _filteredProducts) {
      total += p.trongLuong * p.soLuongLenhSanXuat;
    }
    return total;
  }

  int get totalSoLuongLenhSanXuat {
    int total = 0;
    for (var p in _filteredProducts) {
      total += p.soLuongLenhSanXuat;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Sản phẩm',
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // === SUMMARY ===
            Card(
              margin: EdgeInsets.zero,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Tổng sản phẩm',
                      totalProducts.toString(),
                    ),
                    _buildSummaryItem(
                      'Tổng trọng lượng (kg)',
                      totalWeight.toStringAsFixed(2),
                    ),
                    _buildSummaryItem(
                      'Tổng lệnh SX',
                      totalSoLuongLenhSanXuat.toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // === SEARCH + BUTTONS ===
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: _filterSearch,
                  ),
                ),
                const SizedBox(width: 12),
                GroupActionButtons(
                  onAdd: () => _showAddOrEditDialog(context, null),
                  onImport: () {
                    // Xử lý import ở đây
                  },
                  onExport: () {
                    // Xử lý export ở đây
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // === BẢNG DỮ LIỆU - CỘT ĐỀU ===
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 1400,
                      ), // Đảm bảo đủ rộng
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(150), // Mã SP
                            2: FixedColumnWidth(300), // Tên SP
                            3: FixedColumnWidth(200), // Nhóm SP
                            4: FixedColumnWidth(160), // Trọng lượng
                            5: FixedColumnWidth(80), // Đơn vị
                            6: FixedColumnWidth(160), // SL Lệnh SX
                            7: FixedColumnWidth(130), // Ngày tạo
                            8: FixedColumnWidth(120), // Người tạo
                            9: FixedColumnWidth(140), // Ngày cập nhật
                            10: FixedColumnWidth(100), // Hành động
                          },
                          children: [
                            // === HEADER ===
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                              ),
                              children: [
                                _headerCell(
                                  'STT',
                                  onTap: () => _sort<num>(
                                    (p) => p.stt,
                                    0,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã sản phẩm',
                                  onTap: () => _sort<String>(
                                    (p) => p.maSanPham,
                                    1,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Tên sản phẩm',
                                  onTap: () => _sort<String>(
                                    (p) => p.tenSanPham,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Nhóm sản phẩm',
                                  onTap: () => _sort<String>(
                                    (p) => p.nhomSanPham,
                                    3,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Trọng lượng (kg)',
                                  onTap: () => _sort<num>(
                                    (p) => p.trongLuong,
                                    4,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Đơn vị'),
                                _headerCell(
                                  'Số lượng lệnh SX',
                                  onTap: () => _sort<num>(
                                    (p) => p.soLuongLenhSanXuat,
                                    6,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<DateTime>(
                                    (p) => p.ngayTao,
                                    7,
                                    !_sortAscending,
                                  ),
                                ),

                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<DateTime>(
                                    (p) => p.ngayCapNhat,
                                    9,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Hành động'),
                              ],
                            ),

                            // === DATA ROWS ===
                            ..._filteredProducts.map((p) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: _filteredProducts.indexOf(p) % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(p.stt.toString(), center: true),
                                  _dataCell(p.maSanPham),
                                  _dataCell(p.tenSanPham),
                                  _dataCell(p.nhomSanPham),
                                  _dataCell(
                                    p.trongLuong.toStringAsFixed(2),
                                    center: true,
                                  ),
                                  _dataCell(p.donViTrongLuong, center: true),
                                  _dataCell(
                                    p.soLuongLenhSanXuat.toString(),
                                    center: true,
                                  ),
                                  _dataCell(p.nguoiTao),
                                  _dataCell(
                                    p.ngayTao
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    center: true,
                                  ),
                                  _dataCell(
                                    p.ngayCapNhat
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    center: true,
                                  ),
                                  _actionCell(context, p),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_upward, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _dataCell(String text, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SelectableText(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: center ? TextAlign.center : TextAlign.left,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _actionCell(BuildContext context, ProductModel p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
            onPressed: () => _showAddOrEditDialog(context, p),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
            onPressed: () => setState(() {
              _products.remove(p);
              _filterSearch(searchController.text);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
