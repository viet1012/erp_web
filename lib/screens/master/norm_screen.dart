import 'package:flutter/material.dart';
import '../../models/master/norm_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class NormScreen extends StatefulWidget {
  const NormScreen({super.key});

  @override
  State<NormScreen> createState() => _NormScreenState();
}

class _NormScreenState extends State<NormScreen> {
  late List<NormModel> _norms;
  late List<NormModel> _filteredNorms;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Giả sử có sẵn hàm mockData() trong NormModel, nếu không có bạn tự thêm hoặc load data từ API
    _norms = NormModel.mockData;
    _filteredNorms = List.from(_norms);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredNorms = _norms.where((n) {
        return n.maSanPham.toLowerCase().contains(query.toLowerCase()) ||
            n.tenSanPham.toLowerCase().contains(query.toLowerCase()) ||
            n.tenChiTiet.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(NormModel n) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredNorms.sort((a, b) {
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
    NormModel? norm,
  ) async {
    final isEditing = norm != null;

    final sttCtrl = TextEditingController(
      text: isEditing ? norm!.stt.toString() : (_norms.length + 1).toString(),
    );
    final maSPCtrl = TextEditingController(text: norm?.maSanPham ?? '');
    final tenSPCtrl = TextEditingController(text: norm?.tenSanPham ?? '');
    final maChiTietCtrl = TextEditingController(text: norm?.maChiTiet ?? '');
    final tenChiTietCtrl = TextEditingController(text: norm?.tenChiTiet ?? '');
    final suDungCtrl = TextEditingController(text: norm?.suDung ?? '');
    final donViSuDungCtrl = TextEditingController(
      text: norm?.donViSuDung ?? '',
    );
    final ngayTaoCtrl = TextEditingController(text: norm?.ngayTao ?? '');
    final nguoiTaoCtrl = TextEditingController(text: norm?.nguoiTao ?? '');
    final ngayCapNhatCtrl = TextEditingController(
      text: norm?.ngayCapNhat ?? '',
    );
    final nguoiCapNhatCtrl = TextEditingController(
      text: norm?.nguoiCapNhat ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa Norm' : 'Thêm Norm mới'),
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
                  controller: maChiTietCtrl,
                  decoration: const InputDecoration(labelText: 'Mã chi tiết'),
                ),
                TextField(
                  controller: tenChiTietCtrl,
                  decoration: const InputDecoration(labelText: 'Tên chi tiết'),
                ),
                TextField(
                  controller: suDungCtrl,
                  decoration: const InputDecoration(labelText: 'Sử dụng'),
                ),
                TextField(
                  controller: donViSuDungCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị sử dụng',
                  ),
                ),
                TextField(
                  controller: ngayTaoCtrl,
                  decoration: const InputDecoration(labelText: 'Ngày tạo'),
                ),
                TextField(
                  controller: nguoiTaoCtrl,
                  decoration: const InputDecoration(labelText: 'Người tạo'),
                ),
                TextField(
                  controller: ngayCapNhatCtrl,
                  decoration: const InputDecoration(labelText: 'Ngày cập nhật'),
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
              if (maSPCtrl.text.isEmpty || tenSPCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin'),
                  ),
                );
                return;
              }

              setState(() {
                if (isEditing) {
                  final index = _norms.indexOf(norm!);
                  _norms[index] = NormModel(
                    stt: int.parse(sttCtrl.text),
                    maSanPham: maSPCtrl.text,
                    tenSanPham: tenSPCtrl.text,
                    maChiTiet: maChiTietCtrl.text,
                    tenChiTiet: tenChiTietCtrl.text,
                    suDung: suDungCtrl.text,
                    donViSuDung: donViSuDungCtrl.text,
                    ngayTao: ngayTaoCtrl.text,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatCtrl.text,
                    nguoiCapNhat: nguoiCapNhatCtrl.text,
                  );
                } else {
                  final newItem = NormModel(
                    stt: _norms.length + 1,
                    maSanPham: maSPCtrl.text,
                    tenSanPham: tenSPCtrl.text,
                    maChiTiet: maChiTietCtrl.text,
                    tenChiTiet: tenChiTietCtrl.text,
                    suDung: suDungCtrl.text,
                    donViSuDung: donViSuDungCtrl.text,
                    ngayTao: ngayTaoCtrl.text,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatCtrl.text,
                    nguoiCapNhat: nguoiCapNhatCtrl.text,
                  );
                  _norms.add(newItem);
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

  int get totalNorms => _filteredNorms.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Norm',
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // === SUMMARY ===

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

            // === BẢNG DỮ LIỆU ===
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
                      constraints: const BoxConstraints(minWidth: 1300),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(150), // Mã sản phẩm
                            2: FixedColumnWidth(200), // Tên sản phẩm
                            3: FixedColumnWidth(130), // Mã chi tiết
                            4: FixedColumnWidth(200), // Tên chi tiết
                            5: FixedColumnWidth(100), // Sử dụng
                            6: FixedColumnWidth(160), // Đơn vị sử dụng
                            7: FixedColumnWidth(130), // Ngày tạo
                            8: FixedColumnWidth(120), // Người tạo
                            9: FixedColumnWidth(140), // Ngày cập nhật
                            10: FixedColumnWidth(140), // Người cập nhật
                            11: FixedColumnWidth(100), // Hành động
                          },
                          children: [
                            // HEADER
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                              ),
                              children: [
                                _headerCell(
                                  'STT',
                                  onTap: () => _sort<num>(
                                    (n) => n.stt,
                                    0,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã sản phẩm',
                                  onTap: () => _sort<String>(
                                    (n) => n.maSanPham,
                                    1,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Tên sản phẩm',
                                  onTap: () => _sort<String>(
                                    (n) => n.tenSanPham,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã chi tiết',
                                  onTap: () => _sort<String>(
                                    (n) => n.maChiTiet,
                                    3,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Tên chi tiết',
                                  onTap: () => _sort<String>(
                                    (n) => n.tenChiTiet,
                                    4,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Sử dụng',
                                  onTap: () => _sort<String>(
                                    (n) => n.suDung,
                                    5,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Đơn vị sử dụng',
                                  onTap: () => _sort<String>(
                                    (n) => n.donViSuDung,
                                    6,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<String>(
                                    (n) => n.ngayTao,
                                    7,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<String>(
                                    (n) => n.ngayCapNhat,
                                    9,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người cập nhật'),
                                _headerCell('Hành động'),
                              ],
                            ),

                            // DATA ROWS
                            ..._filteredNorms.map((n) {
                              final index = _filteredNorms.indexOf(n);
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(n.stt.toString(), center: true),
                                  _dataCell(n.maSanPham),
                                  _dataCell(n.tenSanPham),
                                  _dataCell(n.maChiTiet),
                                  _dataCell(n.tenChiTiet),
                                  _dataCell(n.suDung, center: true),
                                  _dataCell(n.donViSuDung, center: true),
                                  _dataCell(n.ngayTao, center: true),
                                  _dataCell(n.nguoiTao),
                                  _dataCell(n.ngayCapNhat, center: true),
                                  _dataCell(n.nguoiCapNhat),
                                  _actionCell(context, n),
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

  Widget _actionCell(BuildContext context, NormModel norm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => _showAddOrEditDialog(context, norm),
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
                    'Bạn có chắc chắn muốn xóa "${norm.tenSanPham}" không?',
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
                  _norms.remove(norm);
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
