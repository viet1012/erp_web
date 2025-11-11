class ProcessCodeModel {
  final int stt;
  final String maCongDoan;
  final String tenCongDoan;
  final double thoiGianGiaCong;
  final DateTime ngayTao;
  final String? nguoiTao;
  final DateTime ngayCapNhat;
  final String? nguoiCapNhat;

  ProcessCodeModel({
    required this.stt,
    required this.maCongDoan,
    required this.tenCongDoan,
    required this.thoiGianGiaCong,
    required this.ngayTao,
    this.nguoiTao,
    required this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  ProcessCodeModel copyWith({
    String? maCongDoan,
    String? tenCongDoan,
    double? thoiGianGiaCong,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
  }) {
    return ProcessCodeModel(
      stt: stt,
      maCongDoan: maCongDoan ?? this.maCongDoan,
      tenCongDoan: tenCongDoan ?? this.tenCongDoan,
      thoiGianGiaCong: thoiGianGiaCong ?? this.thoiGianGiaCong,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }

  // MOCK DATA
  static List<ProcessCodeModel> mockData = [
    ProcessCodeModel(
      stt: 1,
      maCongDoan: 'PD001',
      tenCongDoan: 'Cắt nguyên liệu',
      thoiGianGiaCong: 2.5,
      ngayTao: DateTime(2024, 01, 15),
      nguoiTao: 'Nguyen Van A',
      ngayCapNhat: DateTime(2024, 02, 01),
      nguoiCapNhat: 'Tran Thi B',
    ),
    ProcessCodeModel(
      stt: 2,
      maCongDoan: 'PD002',
      tenCongDoan: 'Hàn ghép',
      thoiGianGiaCong: 3.0,
      ngayTao: DateTime(2024, 01, 16),
      nguoiTao: 'Nguyen Van A',
      ngayCapNhat: DateTime(2024, 02, 05),
      nguoiCapNhat: 'Tran Thi C',
    ),
    ProcessCodeModel(
      stt: 3,
      maCongDoan: 'PD003',
      tenCongDoan: 'Sơn phủ',
      thoiGianGiaCong: 1.75,
      ngayTao: DateTime(2024, 01, 20),
      nguoiTao: 'Le Van D',
      ngayCapNhat: DateTime(2024, 02, 10),
      nguoiCapNhat: 'Pham Thi E',
    ),
    ProcessCodeModel(
      stt: 4,
      maCongDoan: 'PD004',
      tenCongDoan: 'Kiểm tra chất lượng',
      thoiGianGiaCong: 2.0,
      ngayTao: DateTime(2024, 01, 22),
      nguoiTao: 'Pham Van F',
      ngayCapNhat: DateTime(2024, 02, 12),
      nguoiCapNhat: 'Nguyen Van G',
    ),
    ProcessCodeModel(
      stt: 5,
      maCongDoan: 'PD005',
      tenCongDoan: 'Đóng gói',
      thoiGianGiaCong: 1.25,
      ngayTao: DateTime(2024, 01, 25),
      nguoiTao: 'Tran Thi H',
      ngayCapNhat: DateTime(2024, 02, 15),
      nguoiCapNhat: 'Le Van I',
    ),
  ];
}
