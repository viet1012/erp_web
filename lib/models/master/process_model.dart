class ProcessModel {
  final int stt;
  final String maSanPham;
  final String maCongDoan;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  ProcessModel({
    required this.stt,
    required this.maSanPham,
    required this.maCongDoan,
    required this.ngayTao,
    required this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

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

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      stt: json['STT'] ?? 0,
      maSanPham: json['MaSanPham'] ?? '',
      maCongDoan: json['MaCongDoan'] ?? '',
      ngayTao: DateTime.tryParse(json['NgayTao'] ?? '') ?? DateTime.now(),
      nguoiTao: json['NguoiTao'],
      ngayCapNhat: json['NgayCapNhat'] != null
          ? DateTime.tryParse(json['NgayCapNhat'])
          : null,
      nguoiCapNhat: json['NguoiCapNhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaSanPham': maSanPham,
      'MaCongDoan': maCongDoan,
      'NgayTao': ngayTao.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  /// 🧠 Dữ liệu mẫu
  static List<ProcessModel> mockData() {
    return [
      ProcessModel(
        stt: 1,
        maSanPham: 'SP001',
        maCongDoan: 'CD001 - Cắt vật liệu',
        ngayTao: DateTime(2025, 1, 5),
        nguoiTao: 'Nguyễn Văn A',
      ),
      ProcessModel(
        stt: 2,
        maSanPham: 'SP001',
        maCongDoan: 'CD002 - Gia công thô',
        ngayTao: DateTime(2025, 1, 6),
        nguoiTao: 'Trần Văn B',
      ),
      ProcessModel(
        stt: 3,
        maSanPham: 'SP001',
        maCongDoan: 'CD003 - Mài tinh',
        ngayTao: DateTime(2025, 1, 8),
        nguoiTao: 'Lê Thị C',
      ),
      ProcessModel(
        stt: 4,
        maSanPham: 'SP002',
        maCongDoan: 'CD001 - Đúc phôi',
        ngayTao: DateTime(2025, 2, 10),
        nguoiTao: 'Nguyễn Văn D',
      ),
      ProcessModel(
        stt: 5,
        maSanPham: 'SP002',
        maCongDoan: 'CD002 - Gia công CNC',
        ngayTao: DateTime(2025, 2, 12),
        nguoiTao: 'Phạm Thị E',
      ),
      ProcessModel(
        stt: 6,
        maSanPham: 'SP003',
        maCongDoan: 'CD001 - Cắt laser',
        ngayTao: DateTime(2025, 3, 1),
        nguoiTao: 'Lê Minh F',
      ),
      ProcessModel(
        stt: 7,
        maSanPham: 'SP003',
        maCongDoan: 'CD002 - Sơn phủ',
        ngayTao: DateTime(2025, 3, 2),
        nguoiTao: 'Nguyễn Văn G',
      ),
      ProcessModel(
        stt: 8,
        maSanPham: 'SP004',
        maCongDoan: 'CD001 - Lắp ráp',
        ngayTao: DateTime(2025, 4, 10),
        nguoiTao: 'Admin',
      ),
      ProcessModel(
        stt: 9,
        maSanPham: 'SP004',
        maCongDoan: 'CD002 - Kiểm tra chất lượng',
        ngayTao: DateTime(2025, 4, 11),
        nguoiTao: 'Admin',
      ),
      ProcessModel(
        stt: 10,
        maSanPham: 'SP005',
        maCongDoan: 'CD001 - Đóng gói',
        ngayTao: DateTime(2025, 5, 1),
        nguoiTao: 'Lê Văn H',
      ),

      // Thêm 20 công đoạn mới
      ProcessModel(
        stt: 11,
        maSanPham: 'SP006',
        maCongDoan: 'CD001 - Chuẩn bị nguyên liệu',
        ngayTao: DateTime(2025, 5, 2),
        nguoiTao: 'Nguyễn Văn I',
      ),
      ProcessModel(
        stt: 12,
        maSanPham: 'SP006',
        maCongDoan: 'CD002 - Cắt CNC',
        ngayTao: DateTime(2025, 5, 3),
        nguoiTao: 'Trần Thị J',
      ),
      ProcessModel(
        stt: 13,
        maSanPham: 'SP007',
        maCongDoan: 'CD001 - Ép nhựa',
        ngayTao: DateTime(2025, 5, 4),
        nguoiTao: 'Lê Văn K',
      ),
      ProcessModel(
        stt: 14,
        maSanPham: 'SP007',
        maCongDoan: 'CD002 - Lắp ráp bộ phận',
        ngayTao: DateTime(2025, 5, 5),
        nguoiTao: 'Phạm Thị L',
      ),
      ProcessModel(
        stt: 15,
        maSanPham: 'SP008',
        maCongDoan: 'CD001 - Gia công phay',
        ngayTao: DateTime(2025, 5, 6),
        nguoiTao: 'Nguyễn Văn M',
      ),
      ProcessModel(
        stt: 16,
        maSanPham: 'SP008',
        maCongDoan: 'CD002 - Mài bavia',
        ngayTao: DateTime(2025, 5, 7),
        nguoiTao: 'Trần Văn N',
      ),
      ProcessModel(
        stt: 17,
        maSanPham: 'SP009',
        maCongDoan: 'CD001 - Lắp đặt điện',
        ngayTao: DateTime(2025, 5, 8),
        nguoiTao: 'Lê Thị O',
      ),
      ProcessModel(
        stt: 18,
        maSanPham: 'SP009',
        maCongDoan: 'CD002 - Kiểm tra điện',
        ngayTao: DateTime(2025, 5, 9),
        nguoiTao: 'Phạm Văn P',
      ),
      ProcessModel(
        stt: 19,
        maSanPham: 'SP010',
        maCongDoan: 'CD001 - Sơn tĩnh điện',
        ngayTao: DateTime(2025, 5, 10),
        nguoiTao: 'Nguyễn Văn Q',
      ),
      ProcessModel(
        stt: 20,
        maSanPham: 'SP010',
        maCongDoan: 'CD002 - Đóng kiện',
        ngayTao: DateTime(2025, 5, 11),
        nguoiTao: 'Trần Thị R',
      ),
      ProcessModel(
        stt: 21,
        maSanPham: 'SP011',
        maCongDoan: 'CD001 - Cắt tấm',
        ngayTao: DateTime(2025, 5, 12),
        nguoiTao: 'Lê Văn S',
      ),
      ProcessModel(
        stt: 22,
        maSanPham: 'SP011',
        maCongDoan: 'CD002 - Đột dập',
        ngayTao: DateTime(2025, 5, 13),
        nguoiTao: 'Phạm Thị T',
      ),
      ProcessModel(
        stt: 23,
        maSanPham: 'SP012',
        maCongDoan: 'CD001 - Lắp ráp cơ khí',
        ngayTao: DateTime(2025, 5, 14),
        nguoiTao: 'Nguyễn Văn U',
      ),
      ProcessModel(
        stt: 24,
        maSanPham: 'SP012',
        maCongDoan: 'CD002 - Kiểm tra cơ khí',
        ngayTao: DateTime(2025, 5, 15),
        nguoiTao: 'Trần Văn V',
      ),
      ProcessModel(
        stt: 25,
        maSanPham: 'SP013',
        maCongDoan: 'CD001 - Lắp ráp điện tử',
        ngayTao: DateTime(2025, 5, 16),
        nguoiTao: 'Lê Thị W',
      ),
      ProcessModel(
        stt: 26,
        maSanPham: 'SP013',
        maCongDoan: 'CD002 - Kiểm tra điện tử',
        ngayTao: DateTime(2025, 5, 17),
        nguoiTao: 'Phạm Văn X',
      ),
      ProcessModel(
        stt: 27,
        maSanPham: 'SP014',
        maCongDoan: 'CD001 - Mài đánh bóng',
        ngayTao: DateTime(2025, 5, 18),
        nguoiTao: 'Nguyễn Văn Y',
      ),
      ProcessModel(
        stt: 28,
        maSanPham: 'SP014',
        maCongDoan: 'CD002 - Vệ sinh sản phẩm',
        ngayTao: DateTime(2025, 5, 19),
        nguoiTao: 'Trần Thị Z',
      ),
      ProcessModel(
        stt: 29,
        maSanPham: 'SP015',
        maCongDoan: 'CD001 - Kiểm tra cuối cùng',
        ngayTao: DateTime(2025, 5, 20),
        nguoiTao: 'Lê Văn AA',
      ),
      ProcessModel(
        stt: 30,
        maSanPham: 'SP015',
        maCongDoan: 'CD002 - Đóng gói xuất kho',
        ngayTao: DateTime(2025, 5, 21),
        nguoiTao: 'Phạm Thị BB',
      ),
    ];
  }
}
