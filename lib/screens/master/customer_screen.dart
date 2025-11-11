import 'package:flutter/material.dart';

import '../../models/master/customer_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/group_action_buttons.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late List<Customer> _customers;
  late List<Customer> _filteredCustomers;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customers = Customer.mockData();
    _filteredCustomers = List.from(_customers);
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredCustomers = _customers.where((c) {
        return c.maKhachHang.toLowerCase().contains(query.toLowerCase()) ||
            c.tenKhachHang.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sort<T>(
    Comparable<T> Function(Customer c) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredCustomers.sort((a, b) {
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
    Customer? customer,
  ) async {
    final isEditing = customer != null;

    final sttCtrl = TextEditingController(
      text: isEditing
          ? customer!.stt.toString()
          : (_customers.length + 1).toString(),
    );
    final maKHCtrl = TextEditingController(text: customer?.maKhachHang ?? '');
    final tenKHCtrl = TextEditingController(text: customer?.tenKhachHang ?? '');
    final diaChiCtrl = TextEditingController(text: customer?.diaChi ?? '');
    final sdtCtrl = TextEditingController(text: customer?.soDienThoai ?? '');
    final emailCtrl = TextEditingController(text: customer?.email ?? '');
    final mstCtrl = TextEditingController(text: customer?.maSoThue ?? '');
    final ngayTaoCtrl = TextEditingController(
      text: isEditing && customer!.ngayTao != null
          ? customer.ngayTao!.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    final nguoiTaoCtrl = TextEditingController(text: customer?.nguoiTao ?? '');
    final ngayCapNhatCtrl = TextEditingController(
      text: isEditing && customer!.ngayCapNhat != null
          ? customer.ngayCapNhat!.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    final nguoiCapNhatCtrl = TextEditingController(
      text: customer?.nguoiCapNhat ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa Khách hàng' : 'Thêm Khách hàng mới'),
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
                  controller: maKHCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Mã khách hàng *',
                  ),
                ),
                TextField(
                  controller: tenKHCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng *',
                  ),
                ),
                TextField(
                  controller: diaChiCtrl,
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                ),
                TextField(
                  controller: sdtCtrl,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: mstCtrl,
                  decoration: const InputDecoration(labelText: 'Mã số thuế'),
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
              if (maKHCtrl.text.isEmpty || tenKHCtrl.text.isEmpty) {
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
                ngayCapNhatParsed = ngayCapNhatCtrl.text.isNotEmpty
                    ? DateTime.parse(ngayCapNhatCtrl.text)
                    : null;
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
                  final index = _customers.indexOf(customer!);
                  _customers[index] = Customer(
                    stt: int.parse(sttCtrl.text),
                    maKhachHang: maKHCtrl.text,
                    tenKhachHang: tenKHCtrl.text,
                    diaChi: diaChiCtrl.text,
                    soDienThoai: sdtCtrl.text,
                    email: emailCtrl.text,
                    maSoThue: mstCtrl.text,
                    ngayTao: ngayTaoParsed,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatParsed,
                    nguoiCapNhat: nguoiCapNhatCtrl.text.isNotEmpty
                        ? nguoiCapNhatCtrl.text
                        : null,
                  );
                } else {
                  final newItem = Customer(
                    stt: _customers.length + 1,
                    maKhachHang: maKHCtrl.text,
                    tenKhachHang: tenKHCtrl.text,
                    diaChi: diaChiCtrl.text,
                    soDienThoai: sdtCtrl.text,
                    email: emailCtrl.text,
                    maSoThue: mstCtrl.text,
                    ngayTao: ngayTaoParsed,
                    nguoiTao: nguoiTaoCtrl.text,
                    ngayCapNhat: ngayCapNhatParsed,
                    nguoiCapNhat: nguoiCapNhatCtrl.text.isNotEmpty
                        ? nguoiCapNhatCtrl.text
                        : null,
                  );
                  _customers.add(newItem);
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

  int get totalCustomers => _filteredCustomers.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Danh sách Khách hàng',
        backgroundColor: Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo mã hoặc tên khách hàng...',
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
                      constraints: const BoxConstraints(minWidth: 1400),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(80), // STT
                            1: FixedColumnWidth(150), // Mã khách hàng
                            2: FixedColumnWidth(200), // Tên khách hàng
                            3: FixedColumnWidth(200), // Địa chỉ
                            4: FixedColumnWidth(140), // Số điện thoại
                            5: FixedColumnWidth(220), // Email
                            6: FixedColumnWidth(140), // Mã số thuế
                            7: FixedColumnWidth(140), // Ngày tạo
                            8: FixedColumnWidth(120), // Người tạo
                            9: FixedColumnWidth(140), // Ngày cập nhật
                            10: FixedColumnWidth(100), // Hành động
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
                                    (c) => c.stt,
                                    0,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Mã khách hàng',
                                  onTap: () => _sort<String>(
                                    (c) => c.maKhachHang,
                                    1,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell(
                                  'Tên khách hàng',
                                  onTap: () => _sort<String>(
                                    (c) => c.tenKhachHang,
                                    2,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Địa chỉ'),
                                _headerCell('Số điện thoại'),
                                _headerCell('Email'),
                                _headerCell('Mã số thuế'),
                                _headerCell(
                                  'Ngày tạo',
                                  onTap: () => _sort<DateTime?>(
                                    (c) =>
                                        c.ngayTao ??
                                        DateTime.fromMillisecondsSinceEpoch(0),
                                    7,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Người tạo'),
                                _headerCell(
                                  'Ngày cập nhật',
                                  onTap: () => _sort<DateTime?>(
                                    (c) =>
                                        c.ngayCapNhat ??
                                        DateTime.fromMillisecondsSinceEpoch(0),
                                    9,
                                    !_sortAscending,
                                  ),
                                ),
                                _headerCell('Hành động'),
                              ],
                            ),
                            // DATA ROWS
                            ..._filteredCustomers.map((c) {
                              final index = _filteredCustomers.indexOf(c);
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey.shade50
                                      : Colors.white,
                                ),
                                children: [
                                  _dataCell(c.stt.toString(), center: true),
                                  _dataCell(c.maKhachHang),
                                  _dataCell(c.tenKhachHang),
                                  _dataCell(c.diaChi),
                                  _dataCell(c.soDienThoai),
                                  _dataCell(c.email),
                                  _dataCell(c.maSoThue),
                                  _dataCell(
                                    c.ngayTao != null
                                        ? c.ngayTao!
                                              .toIso8601String()
                                              .split('T')
                                              .first
                                        : '',
                                    center: true,
                                  ),
                                  _dataCell(c.nguoiTao ?? ''),
                                  _dataCell(
                                    c.ngayCapNhat != null
                                        ? c.ngayCapNhat!
                                              .toIso8601String()
                                              .split('T')
                                              .first
                                        : '',
                                    center: true,
                                  ),
                                  _actionCell(context, c),
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
            : text == 'Mã khách hàng'
            ? 1
            : text == 'Tên khách hàng'
            ? 2
            : text == 'Ngày tạo'
            ? 7
            : text == 'Ngày cập nhật'
            ? 9
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

  Widget _actionCell(BuildContext context, Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => _showAddOrEditDialog(context, customer),
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
                    'Bạn có chắc chắn muốn xóa khách hàng mã "${customer.maKhachHang}" không?',
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
                  _customers.remove(customer);
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
