class DetailModel {
  final int stt;
  final String maChiTiet;
  final String tenChiTiet;
  final String nhomChiTiet;
  final String donViChiTiet;
  final double trongLuong;
  final String donViTrongLuong;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime ngayCapNhat;
  final String? nguoiCapNhat;

  DetailModel({
    required this.stt,
    required this.maChiTiet,
    required this.tenChiTiet,
    required this.nhomChiTiet,
    required this.donViChiTiet,
    required this.trongLuong,
    required this.donViTrongLuong,
    required this.ngayTao,
    required this.nguoiTao,
    required this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      stt: json['STT'] ?? 0,
      maChiTiet: json['MaChiTiet'] ?? '',
      tenChiTiet: json['TenChiTiet'] ?? '',
      nhomChiTiet: json['NhomChiTiet'] ?? '',
      donViChiTiet: json['DonVi_ChiTiet'] ?? '',
      trongLuong: (json['TrongLuong'] ?? 0).toDouble(),
      donViTrongLuong: json['DonVi_TrongLuong'] ?? '',
      ngayTao: DateTime.tryParse(json['NgayTao'] ?? '') ?? DateTime.now(),
      nguoiTao: json['NguoiTao'] ?? '',
      ngayCapNhat:
          DateTime.tryParse(json['NgayCapNhat'] ?? '') ?? DateTime.now(),
      nguoiCapNhat: json['NguoiCapNhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaChiTiet': maChiTiet,
      'TenChiTiet': tenChiTiet,
      'NhomChiTiet': nhomChiTiet,
      'DonVi_ChiTiet': donViChiTiet,
      'TrongLuong': trongLuong,
      'DonVi_TrongLuong': donViTrongLuong,
      'NgayTao': ngayTao.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  /// ================= MOCK DATA =================
  static List<DetailModel> mockData() {
    final nhomChiTietList = [
      'Chi tiết Trục',
      'Chi tiết Bánh răng',
      'Chi tiết Vỏ hộp',
      'Chi tiết Càng gạt',
      'Chi tiết Bulong – Ốc vít',
    ];

    final tenChiTietList = [
      'Trục cam',
      'Trục vít me',
      'Bánh răng chủ động',
      'Bánh răng bị động',
      'Vỏ hộp giảm tốc',
      'Càng gạt ly hợp',
      'Bạc đỡ trục',
      'Đĩa xích',
      'Trục truyền động',
      'Trục trung gian',
      'Bu lông M10',
      'Bu lông M8',
      'Chốt định vị',
      'Bánh đai',
      'Trục ren',
      'Ốc hãm',
      'Bạc lót',
      'Bánh vít',
      'Càng quay',
      'Nắp bảo vệ',
    ];

    return List.generate(20, (index) {
      final rawWeight = (index + 1) * 0.85 + 0.5;
      final roundedWeight = double.parse(rawWeight.toStringAsFixed(2));

      return DetailModel(
        stt: index + 1,
        maChiTiet: 'CK-${1000 + index}',
        tenChiTiet: tenChiTietList[index],
        nhomChiTiet: nhomChiTietList[index % nhomChiTietList.length],
        donViChiTiet: 'Cái',
        trongLuong: roundedWeight,
        donViTrongLuong: 'Kg',
        ngayTao: DateTime.now().subtract(Duration(days: index * 2)),
        nguoiTao: 'KTV${(index % 3) + 1}',
        ngayCapNhat: DateTime.now().subtract(Duration(days: index)),
        nguoiCapNhat: 'Admin',
      );
    });
  }
}
