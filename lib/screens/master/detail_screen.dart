import 'package:flutter/material.dart';

import '../../models/master/detail_model.dart';

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
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _details = DetailModel.mockData();
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

    final maCtrl = TextEditingController(text: item?.maChiTiet ?? '');
    final tenCtrl = TextEditingController(text: item?.tenChiTiet ?? '');
    final nhomCtrl = TextEditingController(text: item?.nhomChiTiet ?? '');
    final donViChiTietCtrl = TextEditingController(
      text: item?.donViChiTiet ?? '',
    );
    final trongLuongCtrl = TextEditingController(
      text: item?.trongLuong.toString() ?? '',
    );
    final donViTrongLuongCtrl = TextEditingController(
      text: item?.donViTrongLuong ?? '',
    );

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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: trongLuongCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Trọng lượng',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: donViTrongLuongCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Đơn vị trọng lượng',
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: donViChiTietCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị chi tiết',
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
              setState(() {
                if (isEditing) {
                  final index = _details.indexOf(item!);
                  _details[index] = DetailModel(
                    stt: item.stt,
                    maChiTiet: maCtrl.text,
                    tenChiTiet: tenCtrl.text,
                    nhomChiTiet: nhomCtrl.text,
                    donViChiTiet: donViChiTietCtrl.text,
                    trongLuong: double.tryParse(trongLuongCtrl.text) ?? 0,
                    donViTrongLuong: donViTrongLuongCtrl.text,
                    ngayTao: item.ngayTao,
                    nguoiTao: item.nguoiTao,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: 'Admin',
                  );
                } else {
                  final newItem = DetailModel(
                    stt: _details.length + 1,
                    maChiTiet: maCtrl.text,
                    tenChiTiet: tenCtrl.text,
                    nhomChiTiet: nhomCtrl.text,
                    donViChiTiet: donViChiTietCtrl.text,
                    trongLuong: double.tryParse(trongLuongCtrl.text) ?? 0,
                    donViTrongLuong: donViTrongLuongCtrl.text,
                    ngayTao: DateTime.now(),
                    nguoiTao: 'Admin',
                    ngayCapNhat: null,
                    nguoiCapNhat: null,
                  );
                  _details.add(newItem);
                }
                _filterSearch(searchController.text); // refresh filtered list
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToExcel() async {}

  Future<void> _importFromExcel() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Chi tiết'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search + Import/Export + Add
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
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => _showAddOrEditDialog(context, null),
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                  ),
                  onPressed: _importFromExcel,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Import'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                  ),
                  onPressed: _exportToExcel,
                  icon: const Icon(Icons.download),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        Colors.blue.shade800,
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      dataRowColor: MaterialStateProperty.resolveWith<Color?>((
                        Set<MaterialState> states,
                      ) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.blue.shade50;
                        }
                        return null; // default
                      }),
                      sortAscending: _sortAscending,
                      sortColumnIndex: _sortColumnIndex,
                      columns: [
                        DataColumn(
                          label: const Text('STT'),
                          numeric: true,
                          onSort: (index, asc) =>
                              _sort<num>((d) => d.stt, index, asc),
                        ),
                        DataColumn(
                          label: const Text('Mã chi tiết'),
                          onSort: (index, asc) =>
                              _sort<String>((d) => d.maChiTiet, index, asc),
                        ),
                        DataColumn(
                          label: const Text('Tên chi tiết'),
                          onSort: (index, asc) =>
                              _sort<String>((d) => d.tenChiTiet, index, asc),
                        ),
                        DataColumn(
                          label: const Text('Nhóm chi tiết'),
                          onSort: (index, asc) =>
                              _sort<String>((d) => d.nhomChiTiet, index, asc),
                        ),
                        DataColumn(label: const Text('Đơn vị chi tiết')),
                        DataColumn(
                          label: const Text('Trọng lượng'),
                          numeric: true,
                        ),
                        DataColumn(label: const Text('Đơn vị trọng lượng')),
                        DataColumn(label: const Text('Người tạo')),
                        DataColumn(label: const Text('Ngày tạo')),
                        const DataColumn(label: Text('Hành động')),
                      ],
                      rows: _filteredDetails
                          .map(
                            (d) => DataRow(
                              cells: [
                                DataCell(Text(d.stt.toString())),
                                DataCell(Text(d.maChiTiet)),
                                DataCell(Text(d.tenChiTiet)),
                                DataCell(Text(d.nhomChiTiet)),
                                DataCell(Text(d.donViChiTiet)),
                                DataCell(Text(d.trongLuong.toString())),
                                DataCell(Text(d.donViTrongLuong)),
                                DataCell(Text(d.nguoiTao)),
                                DataCell(
                                  Text(
                                    d.ngayTao
                                        .toIso8601String()
                                        .split('T')
                                        .first,
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
                                            _showAddOrEditDialog(context, d),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => setState(() {
                                          _details.remove(d);
                                          _filterSearch(searchController.text);
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
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
}
