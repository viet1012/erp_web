import 'package:flutter/material.dart';
import '../../models/master/process_code_model.dart'; // đổi import tương ứng
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class ProcessCodeScreen extends StatefulWidget {
  const ProcessCodeScreen({super.key});

  @override
  State<ProcessCodeScreen> createState() => _ProcessCodeScreenState();
}

class _ProcessCodeScreenState extends State<ProcessCodeScreen> {
  late List<ProcessCodeModel> _processCodes;
  late List<ProcessCodeModel> _filteredProcessCodes;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Giả sử có sẵn mock data
    _processCodes = ProcessCodeModel.mockData;
    _filteredProcessCodes = List.from(_processCodes);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredProcessCodes = _processCodes.where((p) {
        return p.maCongDoan.toLowerCase().contains(query.toLowerCase()) ||
            p.tenCongDoan.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(ProcessCodeModel p) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredProcessCodes.sort((a, b) {
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
    ProcessCodeModel? processCode,
  ) async {
    final isEditing = processCode != null;

    final sttCtrl = TextEditingController(
      text: isEditing
          ? processCode!.stt.toString()
          : (_processCodes.length + 1).toString(),
    );
    final maCongDoanCtrl = TextEditingController(
      text: processCode?.maCongDoan ?? '',
    );
    final tenCongDoanCtrl = TextEditingController(
      text: processCode?.tenCongDoan ?? '',
    );
    final thoiGianGiaCongCtrl = TextEditingController(
      text: isEditing ? processCode!.thoiGianGiaCong.toString() : '',
    );
    final nguoiTaoCtrl = TextEditingController(
      text: processCode?.nguoiTao ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa Công đoạn' : 'Thêm Công đoạn mới'),
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
                  controller: maCongDoanCtrl,
                  decoration: const InputDecoration(labelText: 'Mã công đoạn'),
                ),
                TextField(
                  controller: tenCongDoanCtrl,
                  decoration: const InputDecoration(labelText: 'Tên công đoạn'),
                ),
                TextField(
                  controller: thoiGianGiaCongCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Thời gian gia công (h)',
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
              if (maCongDoanCtrl.text.isEmpty ||
                  tenCongDoanCtrl.text.isEmpty ||
                  thoiGianGiaCongCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
                  ),
                );
                return;
              }

              setState(() {
                final thoiGianGiaCongParsed =
                    double.tryParse(thoiGianGiaCongCtrl.text) ?? 0;

                if (isEditing) {
                  final index = _processCodes.indexOf(processCode!);
                  _processCodes[index] = ProcessCodeModel(
                    stt: int.parse(sttCtrl.text),
                    maCongDoan: maCongDoanCtrl.text,
                    tenCongDoan: tenCongDoanCtrl.text,
                    thoiGianGiaCong: thoiGianGiaCongParsed,
                    ngayTao: processCode.ngayTao,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: nguoiTaoCtrl.text,
                  );
                } else {
                  final newItem = ProcessCodeModel(
                    stt: _processCodes.length + 1,
                    maCongDoan: maCongDoanCtrl.text,
                    tenCongDoan: tenCongDoanCtrl.text,
                    thoiGianGiaCong: thoiGianGiaCongParsed,
                    ngayTao: DateTime.now(),
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: nguoiTaoCtrl.text,
                  );
                  _processCodes.add(newItem);
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

  int get totalProcessCodes => _filteredProcessCodes.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Mã công đoạn',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSummaryItem(
                      'Tổng công đoạn',
                      totalProcessCodes.toString(),
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
                      constraints: const BoxConstraints(minWidth: 1000),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(180), // Mã công đoạn
                            2: FixedColumnWidth(300), // Tên công đoạn
                            3: FixedColumnWidth(180), // Thời gian gia công
                            4: FixedColumnWidth(150), // Ngày tạo
                            5: FixedColumnWidth(150), // Người tạo
                            6: FixedColumnWidth(150), // Ngày cập nhật
                            7: FixedColumnWidth(150), // Người cập nhật
                            8: FixedColumnWidth(100), // Hành động
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
                                    (p) => p.stt,
                                    0,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã công đoạn',
                                  onTap: () => _sort<String>(
                                    (p) => p.maCongDoan,
                                    1,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Tên công đoạn',
                                  onTap: () => _sort<String>(
                                    (p) => p.tenCongDoan,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Thời gian gia công',
                                  onTap: () => _sort<num>(
                                    (p) => p.thoiGianGiaCong,
                                    3,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<DateTime>(
                                    (p) => p.ngayTao,
                                    4,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<DateTime>(
                                    (p) => p.ngayCapNhat,
                                    6,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người cập nhật'),
                                _headerCell('Hành động'),
                              ],
                            ),

                            // DATA ROWS
                            ..._filteredProcessCodes.map((p) {
                              final index = _filteredProcessCodes.indexOf(p);
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(p.stt.toString(), center: true),
                                  _dataCell(p.maCongDoan),
                                  _dataCell(p.tenCongDoan),
                                  _dataCell(
                                    p.thoiGianGiaCong.toStringAsFixed(2),
                                    center: true,
                                  ),
                                  _dataCell(
                                    p.ngayTao?.toIso8601String() ?? '',
                                    center: true,
                                  ),
                                  _dataCell(p.nguoiTao ?? ''),
                                  _dataCell(
                                    p.ngayCapNhat?.toIso8601String() ?? '',
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
              Icon(
                _sortColumnIndex == 0 && _sortAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
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

  Widget _actionCell(BuildContext context, ProcessCodeModel processCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => _showAddOrEditDialog(context, processCode),
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
                    'Bạn có chắc chắn muốn xóa "${processCode.tenCongDoan}" không?',
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
                  _processCodes.remove(processCode);
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
