// product_model.dart
class ProductModel {
  final int stt;
  final String maSanPham;
  final String tenSanPham;
  final String nhomSanPham;
  final double trongLuong;
  final String donViTrongLuong;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;
  final int soLuongLenhSanXuat;

  ProductModel({
    required this.stt,
    required this.maSanPham,
    required this.tenSanPham,
    required this.nhomSanPham,
    required this.trongLuong,
    required this.donViTrongLuong,
    required this.ngayTao,
    this.ngayCapNhat,
    required this.nguoiTao,
    this.nguoiCapNhat,
    required this.soLuongLenhSanXuat,
  });

  /// JSON → Object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      stt: json['STT'] ?? 0,
      maSanPham: json['MaSanPham'] ?? '',
      tenSanPham: json['TenSanPham'] ?? '',
      nhomSanPham: json['NhomSanPham'] ?? '',
      trongLuong: (json['TrongLuong'] ?? 0).toDouble(),
      donViTrongLuong: json['DonViTrongLuong'] ?? 'kg',
      ngayTao: DateTime.tryParse(json['NgayTao'] ?? '') ?? DateTime.now(),
      nguoiTao: json['NguoiTao'] ?? '',
      ngayCapNhat: json['NgayCapNhat'] != null
          ? DateTime.tryParse(json['NgayCapNhat'])
          : null,
      nguoiCapNhat: json['NguoiCapNhat'],
      soLuongLenhSanXuat: json['SoLuongLenhSanXuat'] ?? 0,
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaSanPham': maSanPham,
      'TenSanPham': tenSanPham,
      'NhomSanPham': nhomSanPham,
      'TrongLuong': trongLuong,
      'DonViTrongLuong': donViTrongLuong,
      'NgayTao': ngayTao.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
      'SoLuongLenhSanXuat': soLuongLenhSanXuat,
    };
  }

  /// Copy object
  ProductModel copyWith({
    int? stt,
    String? maSanPham,
    String? tenSanPham,
    String? nhomSanPham,
    double? trongLuong,
    String? donViTrongLuong,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
    int? soLuongLenhSanXuat,
  }) {
    return ProductModel(
      stt: stt ?? this.stt,
      maSanPham: maSanPham ?? this.maSanPham,
      tenSanPham: tenSanPham ?? this.tenSanPham,
      nhomSanPham: nhomSanPham ?? this.nhomSanPham,
      trongLuong: trongLuong ?? this.trongLuong,
      donViTrongLuong: donViTrongLuong ?? this.donViTrongLuong,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      soLuongLenhSanXuat: soLuongLenhSanXuat ?? this.soLuongLenhSanXuat,
    );
  }

  /// Mock data để test UI hoặc xuất file
  static List<ProductModel> mockData() {
    return [
      ProductModel(
        stt: 1,
        maSanPham: 'SP001',
        tenSanPham: 'Bánh răng thép A1',
        nhomSanPham: 'Cơ khí chính xác',
        trongLuong: 2.5,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 10)),
        nguoiTao: 'Việt',
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: 'Việt',
        soLuongLenhSanXuat: 50,
      ),
      ProductModel(
        stt: 2,
        maSanPham: 'SP002',
        tenSanPham: 'Trục xoay B2',
        nhomSanPham: 'Cơ khí chính xác',
        trongLuong: 4.2,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 8)),
        nguoiTao: 'Tuấn',
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 1)),
        nguoiCapNhat: 'Tuấn',
        soLuongLenhSanXuat: 30,
      ),
      ProductModel(
        stt: 3,
        maSanPham: 'SP003',
        tenSanPham: 'Vỏ hộp động cơ C3',
        nhomSanPham: 'Thiết bị cơ khí',
        trongLuong: 6.8,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 12)),
        nguoiTao: 'Linh',
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 2)),
        nguoiCapNhat: 'Linh',
        soLuongLenhSanXuat: 40,
      ),
      ProductModel(
        stt: 4,
        maSanPham: 'SP004',
        tenSanPham: 'Tấm nhôm gia công D1',
        nhomSanPham: 'Kim loại nhẹ',
        trongLuong: 1.3,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 7)),
        nguoiTao: 'Huy',
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: 'Huy',
        soLuongLenhSanXuat: 70,
      ),
      ProductModel(
        stt: 5,
        maSanPham: 'SP005',
        tenSanPham: 'Khung sắt E2',
        nhomSanPham: 'Vật liệu xây dựng',
        trongLuong: 10.5,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 15)),
        nguoiTao: 'Nam',
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 3)),
        nguoiCapNhat: 'Nam',
        soLuongLenhSanXuat: 25,
      ),
      ProductModel(
        stt: 6,
        maSanPham: 'SP006',
        tenSanPham: 'Ống thép F3',
        nhomSanPham: 'Kim loại nặng',
        trongLuong: 7.6,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 20)),
        nguoiTao: 'Hoa',
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 5)),
        nguoiCapNhat: 'Hoa',
        soLuongLenhSanXuat: 60,
      ),
      ProductModel(
        stt: 7,
        maSanPham: 'SP007',
        tenSanPham: 'Tay nắm cửa G4',
        nhomSanPham: 'Phụ kiện cơ khí',
        trongLuong: 0.8,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 6)),
        nguoiTao: 'Phong',
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: 'Phong',
        soLuongLenhSanXuat: 120,
      ),
      ProductModel(
        stt: 8,
        maSanPham: 'SP008',
        tenSanPham: 'Bulong thép H5',
        nhomSanPham: 'Phụ kiện lắp ráp',
        trongLuong: 0.15,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 3)),
        nguoiTao: 'Duy',
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: 'Duy',
        soLuongLenhSanXuat: 200,
      ),
      ProductModel(
        stt: 9,
        maSanPham: 'SP009',
        tenSanPham: 'Đĩa phanh xe tải K9',
        nhomSanPham: 'Cơ khí ô tô',
        trongLuong: 12.3,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 18)),
        nguoiTao: 'Bình',
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 2)),
        nguoiCapNhat: 'Bình',
        soLuongLenhSanXuat: 35,
      ),
      ProductModel(
        stt: 10,
        maSanPham: 'SP010',
        tenSanPham: 'Nắp van áp suất M1',
        nhomSanPham: 'Cơ khí công nghiệp',
        trongLuong: 2.1,
        donViTrongLuong: 'kg',
        ngayTao: DateTime.now().subtract(const Duration(days: 9)),
        nguoiTao: 'Tâm',
        ngayCapNhat: DateTime.now().subtract(const Duration(days: 1)),
        nguoiCapNhat: 'Tâm',
        soLuongLenhSanXuat: 90,
      ),
    ];
  }
}
