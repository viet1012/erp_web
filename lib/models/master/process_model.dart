class ProcessModel {
  final int stt;
  final String maSanPham;
  final String maCongDoan;
  final DateTime? ngayTao;
  final String? nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  ProcessModel({
    required this.stt,
    required this.maSanPham,
    required this.maCongDoan,
    this.ngayTao,
    this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  /// Chuyển JSON → Object
  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      stt: json['STT'] ?? 0,
      maSanPham: json['MaSanPham'] ?? '',
      maCongDoan: json['MaCongDoan'] ?? '',
      ngayTao: json['NgayTao'] != null
          ? DateTime.tryParse(json['NgayTao'])
          : null,
      nguoiTao: json['NguoiTao'],
      ngayCapNhat: json['NgayCapNhat'] != null
          ? DateTime.tryParse(json['NgayCapNhat'])
          : null,
      nguoiCapNhat: json['NguoiCapNhat'],
    );
  }

  /// Chuyển Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaSanPham': maSanPham,
      'MaCongDoan': maCongDoan,
      'NgayTao': ngayTao?.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  /// Tạo bản sao mới (copy)
  ProcessModel copyWith({
    int? stt,
    String? maSanPham,
    String? maCongDoan,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
  }) {
    return ProcessModel(
      stt: stt ?? this.stt,
      maSanPham: maSanPham ?? this.maSanPham,
      maCongDoan: maCongDoan ?? this.maCongDoan,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }

  /// Mock data
  static List<ProcessModel> mockData() {
    return [
      ProcessModel(
        stt: 1,
        maSanPham: "SP001",
        maCongDoan: "CD01",
        ngayTao: DateTime.now().subtract(const Duration(days: 3)),
        nguoiTao: "Việt",
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: "Việt",
      ),
      ProcessModel(
        stt: 2,
        maSanPham: "SP002",
        maCongDoan: "CD02",
        ngayTao: DateTime.now().subtract(const Duration(days: 2)),
        nguoiTao: "Tuấn",
        ngayCapNhat: DateTime.now().subtract(const Duration(hours: 10)),
        nguoiCapNhat: "Tuấn",
      ),
      ProcessModel(
        stt: 3,
        maSanPham: "SP003",
        maCongDoan: "CD03",
        ngayTao: DateTime.now().subtract(const Duration(days: 1)),
        nguoiTao: "Huy",
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: "Huy",
      ),
      ProcessModel(
        stt: 4,
        maSanPham: "SP004",
        maCongDoan: "CD01",
        ngayTao: DateTime.now().subtract(const Duration(days: 5)),
        nguoiTao: "Linh",
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 1)),
        nguoiCapNhat: "Linh",
      ),
      ProcessModel(
        stt: 5,
        maSanPham: "SP005",
        maCongDoan: "CD04",
        ngayTao: DateTime.now().subtract(const Duration(days: 7)),
        nguoiTao: "Nam",
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 3)),
        nguoiCapNhat: "Nam",
      ),
      ProcessModel(
        stt: 6,
        maSanPham: "SP006",
        maCongDoan: "CD02",
        ngayTao: DateTime.now().subtract(const Duration(days: 10)),
        nguoiTao: "Hoa",
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 5)),
        nguoiCapNhat: "Hoa",
      ),
      ProcessModel(
        stt: 7,
        maSanPham: "SP007",
        maCongDoan: "CD05",
        ngayTao: DateTime.now().subtract(const Duration(days: 4)),
        nguoiTao: "Phong",
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 1)),
        nguoiCapNhat: "Phong",
      ),
      ProcessModel(
        stt: 8,
        maSanPham: "SP008",
        maCongDoan: "CD06",
        ngayTao: DateTime.now().subtract(const Duration(days: 12)),
        nguoiTao: "Duy",
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 6)),
        nguoiCapNhat: "Duy",
      ),
    ];
  }
}
