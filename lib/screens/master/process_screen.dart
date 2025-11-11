import 'package:flutter/material.dart';
import '../../models/master/process_model.dart'; // import model mới
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key});

  @override
  State<ProcessScreen> createState() => _ProcessCodeScreenState();
}

class _ProcessCodeScreenState extends State<ProcessScreen> {
  late List<ProcessModel> _processes;
  late List<ProcessModel> _filteredProcesses;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Giả sử bạn có mock data sẵn cho ProcessModel
    _processes =
        ProcessModel.mockData(); // Bạn cần thêm mockData tương tự như bên ProcessCodeModel
    _filteredProcesses = List.from(_processes);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredProcesses = _processes.where((p) {
        return p.maSanPham.toLowerCase().contains(query.toLowerCase()) ||
            p.maCongDoan.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(ProcessModel p) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredProcesses.sort((a, b) {
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
    ProcessModel? process,
  ) async {
    final isEditing = process != null;

    final sttCtrl = TextEditingController(
      text: isEditing
          ? process!.stt.toString()
          : (_processes.length + 1).toString(),
    );
    final maSPCtrl = TextEditingController(text: process?.maSanPham ?? '');
    final maCongDoanCtrl = TextEditingController(
      text: process?.maCongDoan ?? '',
    );
    final ngayTaoCtrl = TextEditingController(
      text: isEditing
          ? process!.ngayTao.toIso8601String()
          : DateTime.now().toIso8601String(),
    );
    final nguoiTaoCtrl = TextEditingController(text: process?.nguoiTao ?? '');
    final ngayCapNhatCtrl = TextEditingController(
      text: isEditing
          ? (process?.ngayCapNhat != null
                ? process!.ngayCapNhat!.toIso8601String()
                : '')
          : DateTime.now().toIso8601String(),
    );

    final nguoiCapNhatCtrl = TextEditingController(
      text: process?.nguoiCapNhat ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa Process' : 'Thêm Process mới'),
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
                  controller: maCongDoanCtrl,
                  decoration: const InputDecoration(labelText: 'Mã công đoạn'),
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
              if (maSPCtrl.text.isEmpty || maCongDoanCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
                  ),
                );
                return;
              }

              DateTime? ngayTaoParsed;
              DateTime? ngayCapNhatParsed;

              try {
                ngayTaoParsed = DateTime.parse(ngayTaoCtrl.text);
                ngayCapNhatParsed = DateTime.parse(ngayCapNhatCtrl.text);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Ngày không hợp lệ, vui lòng nhập đúng định dạng yyyy-MM-dd',
                    ),
                  ),
                );
                return;
              }

              setState(() {
                if (isEditing) {
                  final index = _processes.indexOf(process!);
                  _processes[index] = ProcessModel(
                    stt: int.parse(sttCtrl.text),
                    maSanPham: maSPCtrl.text,
                    maCongDoan: maCongDoanCtrl.text,
                    ngayTao: ngayTaoParsed!,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatParsed!,
                    nguoiCapNhat: nguoiCapNhatCtrl.text,
                  );
                } else {
                  final newItem = ProcessModel(
                    stt: _processes.length + 1,
                    maSanPham: maSPCtrl.text,
                    maCongDoan: maCongDoanCtrl.text,
                    ngayTao: ngayTaoParsed!,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatParsed!,
                    nguoiCapNhat: nguoiCapNhatCtrl.text,
                  );
                  _processes.add(newItem);
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

  int get totalProcesses => _filteredProcesses.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Công đoạn',
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
                      'Tổng Process',
                      totalProcesses.toString(),
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
                      constraints: const BoxConstraints(minWidth: 900),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(180), // Mã sản phẩm
                            2: FixedColumnWidth(240), // Mã công đoạn
                            3: FixedColumnWidth(160), // Ngày tạo
                            4: FixedColumnWidth(180), // Người tạo
                            5: FixedColumnWidth(160), // Ngày cập nhật
                            6: FixedColumnWidth(150), // Người cập nhật
                            7: FixedColumnWidth(100), // Hành động
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
                                  'Mã sản phẩm',
                                  onTap: () => _sort<String>(
                                    (p) => p.maSanPham,
                                    1,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã công đoạn',
                                  onTap: () => _sort<String>(
                                    (p) => p.maCongDoan,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<DateTime>(
                                    (p) => p.ngayTao,
                                    3,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<DateTime>(
                                    (p) =>
                                        p.ngayCapNhat ??
                                        DateTime.fromMillisecondsSinceEpoch(
                                          0,
                                        ), // Giá trị mặc định nhỏ nhất
                                    5,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người cập nhật'),
                                _headerCell('Hành động'),
                              ],
                            ),

                            // DATA ROWS
                            ..._filteredProcesses.map((p) {
                              final index = _filteredProcesses.indexOf(p);
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(p.stt.toString(), center: true),
                                  _dataCell(p.maSanPham),
                                  _dataCell(p.maCongDoan),
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
            : text == 'Mã công đoạn'
            ? 2
            : text == 'Ngày tạo'
            ? 3
            : text == 'Ngày cập nhật'
            ? 5
            : -1);
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

  Widget _actionCell(BuildContext context, ProcessModel process) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => _showAddOrEditDialog(context, process),
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
                    'Bạn có chắc chắn muốn xóa "${process.maCongDoan}" không?',
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
                  _processes.remove(process);
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
