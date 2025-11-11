import 'package:flutter/material.dart';
import '../../models/master/product_price_model.dart'; // import model mới
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class ProductPriceScreen extends StatefulWidget {
  const ProductPriceScreen({super.key});

  @override
  State<ProductPriceScreen> createState() => _ProductPriceScreenState();
}

class _ProductPriceScreenState extends State<ProductPriceScreen> {
  late List<ProductPriceModel> _products;
  late List<ProductPriceModel> _filteredProducts;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _products = ProductPriceModel.mockData;
    _filteredProducts = List.from(_products);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredProducts = _products.where((p) {
        return p.maSanPham.toLowerCase().contains(query.toLowerCase()) ||
            p.maKhachHang.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(ProductPriceModel p) getField,
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
    ProductPriceModel? product,
  ) async {
    final isEditing = product != null;

    final sttCtrl = TextEditingController(
      text: isEditing
          ? product!.stt.toString()
          : (_products.length + 1).toString(),
    );
    final maSPCtrl = TextEditingController(text: product?.maSanPham ?? '');
    final maKHCtrl = TextEditingController(text: product?.maKhachHang ?? '');
    final donGiaCtrl = TextEditingController(
      text: product?.donGia.toString() ?? '',
    );
    final donViCtrl = TextEditingController(text: product?.donViSuDung ?? '');
    final ngayTaoCtrl = TextEditingController(
      text: isEditing
          ? product!.ngayTao.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    final nguoiTaoCtrl = TextEditingController(text: product?.nguoiTao ?? '');
    final ngayCapNhatCtrl = TextEditingController(
      text: isEditing
          ? (product?.ngayCapNhat != null
                ? product!.ngayCapNhat!.toIso8601String().split('T').first
                : '')
          : DateTime.now().toIso8601String().split('T').first,
    );
    final nguoiCapNhatCtrl = TextEditingController(
      text: product?.nguoiCapNhat ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isEditing
              ? 'Chỉnh sửa Đơn giá sản phẩm'
              : 'Thêm Đơn giá sản phẩm mới',
        ),
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
                  controller: maKHCtrl,
                  decoration: const InputDecoration(labelText: 'Mã khách hàng'),
                ),
                TextField(
                  controller: donGiaCtrl,
                  decoration: const InputDecoration(labelText: 'Đơn giá'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: donViCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị sử dụng',
                  ),
                ),
                TextField(
                  controller: ngayTaoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Ngày tạo (yyyy-MM-dd)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: nguoiTaoCtrl,
                  decoration: const InputDecoration(labelText: 'Người tạo'),
                ),
                TextField(
                  controller: ngayCapNhatCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Ngày cập nhật (yyyy-MM-dd)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: nguoiCapNhatCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Người cập nhật',
                  ),
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
              if (maSPCtrl.text.isEmpty ||
                  maKHCtrl.text.isEmpty ||
                  donGiaCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
                  ),
                );
                return;
              }

              double? donGiaParsed;
              DateTime? ngayTaoParsed;
              DateTime? ngayCapNhatParsed;

              try {
                donGiaParsed = double.parse(donGiaCtrl.text);
                ngayTaoParsed = DateTime.parse(ngayTaoCtrl.text);
                ngayCapNhatParsed = ngayCapNhatCtrl.text.isNotEmpty
                    ? DateTime.parse(ngayCapNhatCtrl.text)
                    : null;
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Dữ liệu không hợp lệ, vui lòng kiểm tra lại định dạng',
                    ),
                  ),
                );
                return;
              }

              setState(() {
                if (isEditing) {
                  final index = _products.indexOf(product!);
                  _products[index] = ProductPriceModel(
                    stt: int.parse(sttCtrl.text),
                    maSanPham: maSPCtrl.text,
                    maKhachHang: maKHCtrl.text,
                    donGia: donGiaParsed!,
                    donViSuDung: donViCtrl.text,
                    ngayTao: ngayTaoParsed!,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatParsed,
                    nguoiCapNhat: nguoiCapNhatCtrl.text.isNotEmpty
                        ? nguoiCapNhatCtrl.text
                        : null,
                  );
                } else {
                  final newItem = ProductPriceModel(
                    stt: _products.length + 1,
                    maSanPham: maSPCtrl.text,
                    maKhachHang: maKHCtrl.text,
                    donGia: donGiaParsed!,
                    donViSuDung: donViCtrl.text,
                    ngayTao: ngayTaoParsed!,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatParsed,
                    nguoiCapNhat: nguoiCapNhatCtrl.text.isNotEmpty
                        ? nguoiCapNhatCtrl.text
                        : null,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Đơn giá sản phẩm',
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSummaryItem('Tổng đơn giá', totalProducts.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText:
                          'Tìm kiếm theo mã sản phẩm hoặc mã khách hàng...',
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
                      constraints: const BoxConstraints(minWidth: 1100),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(150), // Mã sản phẩm
                            2: FixedColumnWidth(200), // Mã khách hàng
                            3: FixedColumnWidth(150), // Đơn giá
                            4: FixedColumnWidth(150), // Đơn vị sử dụng
                            5: FixedColumnWidth(150), // Ngày tạo
                            6: FixedColumnWidth(140), // Người tạo
                            7: FixedColumnWidth(150), // Ngày cập nhật
                            8: FixedColumnWidth(140), // Người cập nhật
                            9: FixedColumnWidth(100), // Hành động
                          },
                          children: [
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
                                  'Mã khách hàng',
                                  onTap: () => _sort<String>(
                                    (p) => p.maKhachHang,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Đơn giá',
                                  onTap: () => _sort<num>(
                                    (p) => p.donGia,
                                    3,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Đơn vị sử dụng'),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<DateTime>(
                                    (p) => p.ngayTao,
                                    5,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<DateTime>(
                                    (p) =>
                                        p.ngayCapNhat ??
                                        DateTime.fromMillisecondsSinceEpoch(0),
                                    7,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người cập nhật'),
                                _headerCell('Hành động'),
                              ],
                            ),
                            ..._filteredProducts.map((p) {
                              final index = _filteredProducts.indexOf(p);
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(p.stt.toString(), center: true),
                                  _dataCell(p.maSanPham),
                                  _dataCell(p.maKhachHang),
                                  _dataCell(
                                    p.donGia.toStringAsFixed(2),
                                    center: true,
                                  ),
                                  _dataCell(p.donViSuDung),
                                  _dataCell(
                                    p.ngayTao
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    center: true,
                                  ),
                                  _dataCell(p.nguoiTao),
                                  _dataCell(
                                    p.ngayCapNhat != null
                                        ? p.ngayCapNhat!
                                              .toIso8601String()
                                              .split('T')
                                              .first
                                        : '',
                                    center: true,
                                  ),
                                  _dataCell(p.nguoiCapNhat ?? ''),
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
    final isSorted =
        _sortColumnIndex ==
        (text == 'STT'
            ? 0
            : text == 'Mã sản phẩm'
            ? 1
            : text == 'Mã khách hàng'
            ? 2
            : text == 'Đơn giá'
            ? 3
            : text == 'Ngày tạo'
            ? 5
            : text == 'Ngày cập nhật'
            ? 7
            : -1);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (onTap != null)
              Icon(
                isSorted
                    ? (_sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
                color: Colors.white,
              ),
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

  Widget _actionCell(BuildContext context, ProductPriceModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => _showAddOrEditDialog(context, product),
            tooltip: 'Sửa',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xác nhận xóa'),
                  content: Text(
                    'Bạn có chắc chắn muốn xóa đơn giá sản phẩm mã "${product.maSanPham}" không?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                setState(() {
                  _products.remove(product);
                  _filterSearch(searchController.text);
                });
              }
            },
            tooltip: 'Xóa',
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
