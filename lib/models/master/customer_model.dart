class Customer {
  final int stt;
  final String maKhachHang;
  final String tenKhachHang;
  final String diaChi;
  final String soDienThoai;
  final String email;
  final String maSoThue;
  final DateTime? ngayTao;
  final String? nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  Customer({
    required this.stt,
    required this.maKhachHang,
    required this.tenKhachHang,
    required this.diaChi,
    required this.soDienThoai,
    required this.email,
    required this.maSoThue,
    this.ngayTao,
    this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      stt: json['STT'] ?? 0,
      maKhachHang: json['MaKhachHang'] ?? '',
      tenKhachHang: json['TenKhachHang'] ?? '',
      diaChi: json['DiaChi'] ?? '',
      soDienThoai: json['SoDienThoai'] ?? '',
      email: json['Email'] ?? '',
      maSoThue: json['MaSoThue'] ?? '',
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

  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaKhachHang': maKhachHang,
      'TenKhachHang': tenKhachHang,
      'DiaChi': diaChi,
      'SoDienThoai': soDienThoai,
      'Email': email,
      'MaSoThue': maSoThue,
      'NgayTao': ngayTao?.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  Customer copyWith({
    int? stt,
    String? maKhachHang,
    String? tenKhachHang,
    String? diaChi,
    String? soDienThoai,
    String? email,
    String? maSoThue,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
  }) {
    return Customer(
      stt: stt ?? this.stt,
      maKhachHang: maKhachHang ?? this.maKhachHang,
      tenKhachHang: tenKhachHang ?? this.tenKhachHang,
      diaChi: diaChi ?? this.diaChi,
      soDienThoai: soDienThoai ?? this.soDienThoai,
      email: email ?? this.email,
      maSoThue: maSoThue ?? this.maSoThue,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }

  /// ================= MOCK DATA =================
  static List<Customer> mockData() {
    final tenKhachHangList = [
      'Công ty TNHH Cơ khí Việt Nhật',
      'Công ty CP Cơ khí Hoàng Long',
      'Công ty TNHH Kỹ thuật Minh Tâm',
      'Công ty TNHH TM & SX Phú Cường',
      'Công ty TNHH Cơ khí An Phát',
      'Công ty TNHH Sản xuất Nam Hưng',
      'Công ty TNHH Công nghiệp Đông Á',
      'Công ty CP Thiết bị Cơ khí Bắc Việt',
      'Công ty TNHH Cơ khí Hòa Bình',
      'Công ty TNHH Cơ khí Thành Công',
      'Công ty CP Thương mại và Dịch vụ Thái Sơn',
      'Công ty TNHH Sản xuất và Thương mại Hoàng Gia',
      'Công ty CP Thiết bị Công nghiệp Hòa Phát',
      'Công ty TNHH Kỹ thuật và Đầu tư Tân Việt',
      'Công ty TNHH Sản xuất Đồ gỗ Đức Long',
      'Công ty CP Thiết bị Cơ khí Việt Phát',
      'Công ty TNHH Sản xuất Thương mại Nam Anh',
      'Công ty TNHH Thiết bị Điện Thái Bình',
      'Công ty CP Vật liệu Xây dựng Bắc Hà',
      'Công ty TNHH TM & DV Xây dựng Minh Quân',
    ];

    final diaChiList = [
      'KCN VSIP, Bình Dương',
      'Hải Phòng',
      'KCN Tân Tạo, TP. Hồ Chí Minh',
      'KCN Quang Minh, Hà Nội',
      'KCN Long Hậu, Long An',
      'KCN Biên Hòa 2, Đồng Nai',
      'KCN Nam Cấm, Nghệ An',
      'KCN Tràng Duệ, Hải Phòng',
      'Bắc Ninh',
      'KCN Yên Phong, Bắc Ninh',
      'KCN Đại Đồng, Bắc Ninh',
      'KCN Thạch Thất, Hà Nội',
      'KCN Phúc Sơn, Nghệ An',
      'KCN Tân Bình, TP. Hồ Chí Minh',
      'KCN Đồng Văn, Hà Nam',
      'KCN Quế Võ, Bắc Ninh',
      'KCN Trà Nóc, Cần Thơ',
      'KCN Đình Vũ, Hải Phòng',
      'KCN Hiệp Phước, TP. Hồ Chí Minh',
      'KCN Tam Điệp, Ninh Bình',
    ];

    return List.generate(20, (index) {
      final id = 1000 + index;
      return Customer(
        stt: index + 1,
        maKhachHang: 'KH$id',
        tenKhachHang: tenKhachHangList[index],
        diaChi: diaChiList[index],
        soDienThoai: '090${index}23456',
        email: 'contact${index}@company.com',
        maSoThue: '010${index}56789',
        ngayTao: DateTime.now().subtract(Duration(days: index * 3)),
        nguoiTao: 'Admin',
        ngayCapNhat: DateTime.now().subtract(Duration(days: index)),
        nguoiCapNhat: 'User${(index % 3) + 1}',
      );
    });
  }
}
