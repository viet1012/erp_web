import 'package:flutter/foundation.dart';
import 'dart:math';

class ProductPriceModel {
  final int stt;
  final String maSanPham;
  final String maKhachHang;
  final double donGia;
  final String donViSuDung;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  ProductPriceModel({
    required this.stt,
    required this.maSanPham,
    required this.maKhachHang,
    required this.donGia,
    required this.donViSuDung,
    required this.ngayTao,
    required this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) {
    return ProductPriceModel(
      stt: json['STT'] ?? 0,
      maSanPham: json['MaSanPham'] ?? '',
      maKhachHang: json['MaKhachHang'] ?? '',
      donGia: (json['DonGia'] ?? 0).toDouble(),
      donViSuDung: json['DonVi_SuDung'] ?? '',
      ngayTao: DateTime.tryParse(json['NgayTao'] ?? '') ?? DateTime.now(),
      nguoiTao: json['NguoiTao'] ?? '',
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
      'MaKhachHang': maKhachHang,
      'DonGia': donGia,
      'DonVi_SuDung': donViSuDung,
      'NgayTao': ngayTao.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  // 🧩 Mock data để test hiển thị
  static List<ProductPriceModel> mockData = List.generate(20, (index) {
    final random = Random();
    final customers = ['KH001', 'KH002', 'KH003', 'KH004', 'KH005'];
    final products = [
      'SP001',
      'SP002',
      'SP003',
      'SP004',
      'SP005',
      'SP006',
      'SP007',
      'SP008',
    ];
    final units = ['PCS', 'SET', 'BOX', 'KG', 'M'];

    return ProductPriceModel(
      stt: index + 1,
      maSanPham: products[random.nextInt(products.length)],
      maKhachHang: customers[random.nextInt(customers.length)],
      donGia: (random.nextDouble() * 10000 + 5000).roundToDouble(),
      donViSuDung: units[random.nextInt(units.length)],
      ngayTao: DateTime.now().subtract(Duration(days: random.nextInt(100))),
      nguoiTao: 'Admin${random.nextInt(3) + 1}',
      ngayCapNhat: random.nextBool()
          ? DateTime.now().subtract(Duration(days: random.nextInt(30)))
          : null,
      nguoiCapNhat: random.nextBool() ? 'User${random.nextInt(4) + 1}' : null,
    );
  });
}
