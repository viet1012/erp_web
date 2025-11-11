import 'package:flutter/material.dart';
import '../../models/master/detail_model.dart'; // bạn nhớ sửa path đúng với model mới
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<DetailModel> _details;
  late List<DetailModel> _filteredDetails;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _details =
        DetailModel.mockData(); // bạn tự tạo hàm mockData() trong model hoặc thay bằng dữ liệu thật
    _filteredDetails = List.from(_details);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredDetails = _details.where((d) {
        return d.maChiTiet.toLowerCase().contains(query.toLowerCase()) ||
            d.tenChiTiet.toLowerCase().contains(query.toLowerCase()) ||
            d.nhomChiTiet.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(DetailModel d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredDetails.sort((a, b) {
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
    DetailModel? item,
  ) async {
    final isEditing = item != null;

    final sttCtrl = TextEditingController(
      text: isEditing ? item!.stt.toString() : (_details.length + 1).toString(),
    );
    final maCtrl = TextEditingController(text: item?.maChiTiet ?? '');
    final tenCtrl = TextEditingController(text: item?.tenChiTiet ?? '');
    final nhomCtrl = TextEditingController(text: item?.nhomChiTiet ?? '');
    final donViChiTietCtrl = TextEditingController(
      text: item?.donViChiTiet ?? '',
    );
    final trongLuongCtrl = TextEditingController(
      text: isEditing ? item!.trongLuong.toString() : '',
    );
    final donViTrongLuongCtrl = TextEditingController(
      text: item?.donViTrongLuong ?? 'kg',
    );
    final nguoiTaoCtrl = TextEditingController(text: item?.nguoiTao ?? 'Admin');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa chi tiết' : 'Thêm chi tiết mới'),
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
                  controller: maCtrl,
                  decoration: const InputDecoration(labelText: 'Mã chi tiết'),
                ),
                TextField(
                  controller: tenCtrl,
                  decoration: const InputDecoration(labelText: 'Tên chi tiết'),
                ),
                TextField(
                  controller: nhomCtrl,
                  decoration: const InputDecoration(labelText: 'Nhóm chi tiết'),
                ),
                TextField(
                  controller: donViChiTietCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị chi tiết',
                  ),
                ),
                TextField(
                  controller: trongLuongCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Trọng lượng (kg)',
                  ),
                ),
                TextField(
                  controller: donViTrongLuongCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị trọng lượng',
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
              final stt = int.tryParse(sttCtrl.text) ?? (_details.length + 1);
              final trongLuong = double.tryParse(trongLuongCtrl.text) ?? 0;

              if (maCtrl.text.isEmpty ||
                  tenCtrl.text.isEmpty ||
                  nhomCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin'),
                  ),
                );
                return;
              }

              setState(() {
                if (isEditing) {
                  final index = _details.indexOf(item!);
                  _details[index] = DetailModel(
                    stt: stt,
                    maChiTiet: maCtrl.text,
                    tenChiTiet: tenCtrl.text,
                    nhomChiTiet: nhomCtrl.text,
                    donViChiTiet: donViChiTietCtrl.text,
                    trongLuong: trongLuong,
                    donViTrongLuong: donViTrongLuongCtrl.text,
                    ngayTao: item.ngayTao,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: nguoiTaoCtrl.text,
                  );
                } else {
                  final newItem = DetailModel(
                    stt: _details.length + 1,
                    maChiTiet: maCtrl.text,
                    tenChiTiet: tenCtrl.text,
                    nhomChiTiet: nhomCtrl.text,
                    donViChiTiet: donViChiTietCtrl.text,
                    trongLuong: trongLuong,
                    donViTrongLuong: donViTrongLuongCtrl.text,
                    ngayTao: DateTime.now(),
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: DateTime.now(),
                  );
                  _details.add(newItem);
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

  int get totalDetails => _filteredDetails.length;

  double get totalWeight {
    double total = 0;
    for (var d in _filteredDetails) {
      total += d.trongLuong;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Chi tiết',
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // SUMMARY
            Card(
              margin: EdgeInsets.zero,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Tổng chi tiết', totalDetails.toString()),
                    _buildSummaryItem(
                      'Tổng trọng lượng (kg)',
                      totalWeight.toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // SEARCH + BUTTONS
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

            // TABLE
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
                      constraints: BoxConstraints(minWidth: 1200),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(150), // Mã chi tiết
                            2: FixedColumnWidth(280), // Tên chi tiết
                            3: FixedColumnWidth(200), // Nhóm chi tiết
                            4: FixedColumnWidth(120), // Đơn vị chi tiết
                            5: FixedColumnWidth(160), // Trọng lượng
                            6: FixedColumnWidth(160), // Đơn vị trọng lượng
                            7: FixedColumnWidth(130), // Người tạo
                            8: FixedColumnWidth(120), // Ngày tạo
                            9: FixedColumnWidth(140), // Ngày cập nhật
                            10: FixedColumnWidth(100), // Hành động
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
                                    (d) => d.stt,
                                    0,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã chi tiết',
                                  onTap: () => _sort<String>(
                                    (d) => d.maChiTiet,
                                    1,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Tên chi tiết',
                                  onTap: () => _sort<String>(
                                    (d) => d.tenChiTiet,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Nhóm chi tiết',
                                  onTap: () => _sort<String>(
                                    (d) => d.nhomChiTiet,
                                    3,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Đơn vị chi tiết'),
                                _headerCell(
                                  'Trọng lượng (kg)',
                                  onTap: () => _sort<num>(
                                    (d) => d.trongLuong,
                                    5,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Đơn vị trọng lượng'),
                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<DateTime>(
                                    (d) => d.ngayTao,
                                    8,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<DateTime>(
                                    (d) => d.ngayCapNhat,
                                    9,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Hành động'),
                              ],
                            ),
                            ..._filteredDetails.map((d) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: _filteredDetails.indexOf(d) % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(d.stt.toString(), center: true),
                                  _dataCell(d.maChiTiet),
                                  _dataCell(d.tenChiTiet),
                                  _dataCell(d.nhomChiTiet),
                                  _dataCell(d.donViChiTiet, center: true),
                                  _dataCell(
                                    d.trongLuong.toStringAsFixed(2),
                                    center: true,
                                  ),
                                  _dataCell(d.donViTrongLuong, center: true),
                                  _dataCell(d.nguoiTao),
                                  _dataCell(
                                    d.ngayTao
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    center: true,
                                  ),
                                  _dataCell(
                                    d.ngayCapNhat
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    center: true,
                                  ),
                                  _actionCell(context, d),
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

  Widget _actionCell(BuildContext context, DetailModel d) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
            onPressed: () => _showAddOrEditDialog(context, d),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
            onPressed: () => setState(() {
              _details.remove(d);
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
