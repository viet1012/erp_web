import 'package:flutter/material.dart';
import '../../models/baoGia_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class BaoGiaScreen extends StatefulWidget {
  const BaoGiaScreen({super.key});

  @override
  State<BaoGiaScreen> createState() => _BaoGiaScreenState();
}

class _BaoGiaScreenState extends State<BaoGiaScreen> {
  late List<BaoGiaModel> _baoGiaList;
  late List<BaoGiaModel> _filteredList;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _baoGiaList = mockBaoGiaData;
    _filteredList = List.from(_baoGiaList);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredList = _baoGiaList.where((item) {
        return item.maBaoGia.toLowerCase().contains(query.toLowerCase()) ||
            item.tenSanPham.toLowerCase().contains(query.toLowerCase()) ||
            item.maKhachHang.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(BaoGiaModel p) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredList.sort((a, b) {
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã đặt hàng':
        return Colors.green.shade600;
      case 'Đã hủy':
        return Colors.red.shade600;
      case 'Đang chờ':
        return Colors.orange.shade700;
      case 'Đã xác nhận':
        return Colors.blue.shade700;
      case 'Chờ xác nhận':
        return Colors.deepOrange.shade400;
      case 'Đang xử lý':
        return Colors.purple.shade600;
      case 'Hoàn thành':
        return Colors.teal.shade600;
      case 'Bị trả lại':
        return Colors.brown.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final maBaoGiaCtrl = TextEditingController();
    final maKhachHangCtrl = TextEditingController();
    final tenSanPhamCtrl = TextEditingController();
    final ngayGuiCtrl = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first,
    );
    final ngayGiaoYCCtrl = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first,
    );
    final ngayXacNhanKHCtr = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first,
    );
    final soLuongCtrl = TextEditingController();
    final donGiaCtrl = TextEditingController();
    final donViTienTeCtrl = TextEditingController(text: 'VND');
    final ghiChuCtrl = TextEditingController();

    List<String> statusList = [
      'Đã đặt hàng',
      'Đã hủy',
      'Đang chờ',
      'Đã xác nhận',
      'Chờ xác nhận',
      'Đang xử lý',
      'Hoàn thành',
      'Bị trả lại',
    ];
    String selectedStatus = statusList[0];

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Thêm Báo giá mới'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: maBaoGiaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Mã Báo giá *',
                      ),
                    ),
                    TextField(
                      controller: maKhachHangCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Mã Khách hàng *',
                      ),
                    ),
                    TextField(
                      controller: tenSanPhamCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tên sản phẩm *',
                      ),
                    ),
                    TextField(
                      controller: ngayGuiCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Ngày gửi (yyyy-MM-dd) *',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: ngayGiaoYCCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Ngày giao YC (yyyy-MM-dd) *',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: ngayXacNhanKHCtr,
                      decoration: const InputDecoration(
                        labelText: 'Ngày xác nhận KH (yyyy-MM-dd) *',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: soLuongCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng *',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: donGiaCtrl,
                      decoration: const InputDecoration(labelText: 'Đơn giá *'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: donViTienTeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Đơn vị tiền tệ',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Trạng thái',
                      ),
                      items: statusList
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setStateDialog(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: ghiChuCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Ghi chú'),
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
                onPressed: () {
                  // Validate dữ liệu
                  if (maBaoGiaCtrl.text.isEmpty ||
                      maKhachHangCtrl.text.isEmpty ||
                      tenSanPhamCtrl.text.isEmpty ||
                      soLuongCtrl.text.isEmpty ||
                      donGiaCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vui lòng nhập đầy đủ các trường bắt buộc (*)',
                        ),
                      ),
                    );
                    return;
                  }

                  DateTime? ngayGui, ngayGiaoYC, ngayXacNhanKH;
                  int? soLuong;
                  double? donGia;

                  try {
                    ngayGui = DateTime.parse(ngayGuiCtrl.text);
                    ngayGiaoYC = DateTime.parse(ngayGiaoYCCtrl.text);
                    ngayXacNhanKH = DateTime.parse(ngayXacNhanKHCtr.text);
                    soLuong = int.parse(soLuongCtrl.text);
                    donGia = double.parse(donGiaCtrl.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Dữ liệu ngày, số lượng hoặc đơn giá không hợp lệ',
                        ),
                      ),
                    );
                    return;
                  }

                  final tongTien = soLuong! * donGia!;

                  setState(() {
                    final newItem = BaoGiaModel(
                      maBaoGia: maBaoGiaCtrl.text,
                      maKhachHang: maKhachHangCtrl.text,
                      tenSanPham: tenSanPhamCtrl.text,
                      ngayGui: ngayGui!,
                      ngayGiaoYC: ngayGiaoYC!,
                      ngayXacNhanKH: ngayXacNhanKH!,
                      soLuong: soLuong!,
                      donGia: donGia!,
                      tongTien: tongTien,
                      donViTienTe: donViTienTeCtrl.text,
                      trangThai: selectedStatus,
                      ghiChu: ghiChuCtrl.text.isEmpty ? null : ghiChuCtrl.text,
                      ngayTao: DateTime.now(),
                      nguoiTao:
                          'Người dùng', // Bạn có thể thay thành user thực tế
                      ngayCapNhat: DateTime.now(),
                      nguoiCapNhat: 'Người dùng',
                    );
                    _baoGiaList.add(newItem);
                    _filterSearch(searchController.text);
                  });

                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Báo giá',
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Tìm kiếm + Buttons
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm mã, sản phẩm, khách hàng...',
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
                  onAdd: () {
                    _showAddDialog(context);
                  },
                  onImport: () {
                    // Xử lý import
                  },
                  onExport: () {
                    // Xử lý export
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bảng dữ liệu
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
                      constraints: const BoxConstraints(minWidth: 1200),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          columnWidths: const {
                            0: FixedColumnWidth(120), // Mã Báo giá
                            1: FixedColumnWidth(120), // Mã Khách hàng
                            2: FixedColumnWidth(250), // Tên sản phẩm
                            3: FixedColumnWidth(120), // Ngày gửi
                            4: FixedColumnWidth(140), // Ngày giao YC
                            5: FixedColumnWidth(140), // Ngày xác nhận KH
                            6: FixedColumnWidth(100), // Số lượng
                            7: FixedColumnWidth(100), // Đơn giá
                            8: FixedColumnWidth(120), // Tổng tiền
                            9: FixedColumnWidth(100), // Đơn vị tiền tệ
                            10: FixedColumnWidth(120), // Trạng thái
                            11: FixedColumnWidth(200), // Ghi chú
                            12: FixedColumnWidth(120), // Ngày tạo
                            13: FixedColumnWidth(140), // Người tạo
                            14: FixedColumnWidth(140), // Ngày cập nhật
                            15: FixedColumnWidth(150), // Người cập nhật
                            16: FixedColumnWidth(120), // Người cập nhật
                          },
                          children: [
                            // Header
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                              ),
                              children: [
                                _headerCell('Mã BG', 0, (p) => p.maBaoGia),
                                _headerCell('Mã KH', 1, (p) => p.maKhachHang),
                                _headerCell(
                                  'Tên sản phẩm',
                                  2,
                                  (p) => p.tenSanPham,
                                ),
                                _headerCell('Ngày gửi', 3, (p) => p.ngayGui),
                                _headerCell(
                                  'Ngày giao YC',
                                  4,
                                  (p) => p.ngayGiaoYC,
                                ),
                                _headerCell(
                                  'Ngày xác nhận',
                                  5,
                                  (p) => p.ngayXacNhanKH,
                                ),
                                _headerCell('Số lượng', 6, (p) => p.soLuong),
                                _headerCell('Đơn giá', 7, (p) => p.donGia),
                                _headerCell('Tổng tiền', 8, (p) => p.tongTien),
                                _headerCell('Đơn vị', 9, (p) => p.donViTienTe),
                                _headerCell(
                                  'Trạng thái',
                                  10,
                                  (p) => p.trangThai,
                                ),
                                _headerCell(
                                  'Ghi chú',
                                  11,
                                  (p) => p.ghiChu ?? '',
                                ),
                                _headerCell('Ngày tạo', 12, (p) => p.ngayTao),
                                _headerCell('Người tạo', 13, (p) => p.nguoiTao),
                                _headerCell(
                                  'Ngày cập nhật',
                                  14,
                                  (p) => p.ngayCapNhat ?? DateTime(0),
                                ),
                                _headerCell(
                                  'Người cập nhật',
                                  15,
                                  (p) => p.nguoiCapNhat ?? '',
                                ),
                                _headerCell('Hành động', 16, (p) => p.maBaoGia),
                              ],
                            ),

                            // Data rows
                            ..._filteredList.map((item) {
                              final idx = _filteredList.indexOf(item);
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: idx % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(item.maBaoGia, center: true),
                                  _dataCell(item.maKhachHang, center: true),
                                  _dataCell(item.tenSanPham),
                                  _dataCell(
                                    _formatDate(item.ngayGui),
                                    center: true,
                                  ),
                                  _dataCell(
                                    _formatDate(item.ngayGiaoYC),
                                    center: true,
                                  ),
                                  _dataCell(
                                    _formatDate(item.ngayXacNhanKH),
                                    center: true,
                                  ),
                                  _dataCell(
                                    item.soLuong.toString(),
                                    center: true,
                                  ),
                                  _dataCell(
                                    item.donGia.toStringAsFixed(0),
                                    center: true,
                                  ),
                                  _dataCell(
                                    item.tongTien.toStringAsFixed(0),
                                    center: true,
                                  ),
                                  _dataCell(item.donViTienTe, center: true),
                                  // trạng thái với màu
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      item.trangThai,
                                      style: TextStyle(
                                        color: _getStatusColor(item.trangThai),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  _dataCell(item.ghiChu ?? ''),
                                  _dataCell(
                                    _formatDate(item.ngayTao),
                                    center: true,
                                  ),
                                  _dataCell(item.nguoiTao),
                                  _dataCell(
                                    item.ngayCapNhat != null
                                        ? _formatDate(item.ngayCapNhat!)
                                        : '',
                                    center: true,
                                  ),
                                  _dataCell(item.nguoiCapNhat ?? ''),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          tooltip: 'Sửa',
                                          onPressed: () => _onEdit(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          tooltip: 'Xóa',
                                          onPressed: () => _onDelete(item),
                                        ),
                                      ],
                                    ),
                                  ),
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

  Widget _headerCell<T>(
    String text,
    int columnIndex,
    Comparable<T> Function(BaoGiaModel p) getField,
  ) {
    final isSorted = _sortColumnIndex == columnIndex;
    return InkWell(
      onTap: () => _sort(getField, columnIndex, !_sortAscending),
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
            Icon(
              isSorted
                  ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
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
      ),
    );
  }

  void _onEdit(BaoGiaModel item) {
    final List<String> statusList = [
      'Đã đặt hàng',
      'Đã hủy',
      'Đang chờ',
      'Đã xác nhận',
      'Chờ xác nhận',
      'Đang xử lý',
      'Hoàn thành',
      'Bị trả lại',
    ];

    TextEditingController ghiChuController = TextEditingController(
      text: item.ghiChu,
    );
    String selectedStatus = item.trangThai;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Sửa Báo giá ${item.maBaoGia}'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown trạng thái
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Trạng thái',
                      ),
                      items: statusList
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setStateDialog(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Ghi chú
                    TextField(
                      controller: ghiChuController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Huỷ'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final index = _baoGiaList.indexWhere(
                        (e) => e.maBaoGia == item.maBaoGia,
                      );
                      if (index != -1) {
                        final updated = BaoGiaModel(
                          maBaoGia: item.maBaoGia,
                          maKhachHang: item.maKhachHang,
                          tenSanPham: item.tenSanPham,
                          ngayGui: item.ngayGui,
                          ngayGiaoYC: item.ngayGiaoYC,
                          ngayXacNhanKH: item.ngayXacNhanKH,
                          soLuong: item.soLuong,
                          donGia: item.donGia,
                          tongTien: item.tongTien,
                          donViTienTe: item.donViTienTe,
                          trangThai: selectedStatus,
                          ghiChu: ghiChuController.text,
                          ngayTao: item.ngayTao,
                          nguoiTao: item.nguoiTao,
                          ngayCapNhat: DateTime.now(),
                          nguoiCapNhat: 'Người dùng', // Hoặc lấy user thực tế
                        );
                        _baoGiaList[index] = updated;
                        _filterSearch(searchController.text);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onDelete(BaoGiaModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn xóa báo giá ${item.maBaoGia}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _baoGiaList.removeWhere((e) => e.maBaoGia == item.maBaoGia);
                  _filterSearch(searchController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;
}
