import 'package:flutter/material.dart';

/// Mô hình dữ liệu cho menu có thể lồng nhiều cấp
class MenuModel {
  final String title; // Tên menu hiển thị
  final List<MenuModel> subMenus; // Danh sách menu con
  final IconData? icon; // Icon tùy chọn
  final bool isLeaf; // Có phải là menu cuối (không có con)

  MenuModel(this.title, [this.subMenus = const [], this.icon])
    : isLeaf = subMenus.isEmpty;

  /// Tìm tất cả các menu con (flatten)
  List<MenuModel> flatten() {
    List<MenuModel> all = [this];
    for (final sub in subMenus) {
      all.addAll(sub.flatten());
    }
    return all;
  }

  /// Tìm menu theo tên (dạng đệ quy)
  MenuModel? findByTitle(String name) {
    if (title == name) return this;
    for (final sub in subMenus) {
      final found = sub.findByTitle(name);
      if (found != null) return found;
    }
    return null;
  }

  /// In ra cấu trúc (debug)
  void printTree([String indent = ""]) {
    print('$indent$title');
    for (final sub in subMenus) {
      sub.printTree("$indent  └── ");
    }
  }
}

final List<MenuModel> menuList = [
  MenuModel('Tổng quan', [], Icons.dashboard),

  MenuModel('Quản lý đơn hàng', [
    MenuModel('Danh sách báo giá', [], Icons.format_list_bulleted),
    MenuModel('Danh sách đơn hàng', [], Icons.shopping_cart),
    MenuModel('Tiến độ đơn hàng', [], Icons.timelapse),
    MenuModel('Đơn hàng xuất', [], Icons.local_shipping),
  ], Icons.assignment),

  MenuModel(
    'Quản lý kho',
    [
      MenuModel('Kho vật liệu', [], Icons.store),
      MenuModel('Kho dụng cụ', [], Icons.build),
      MenuModel('Kho bán thành phẩm', [], Icons.all_inbox),
    ],
    Icons.warehouse,
  ), // warehouse icon cần thêm package font_awesome hoặc thay icon khác

  MenuModel('Quản lý master', [
    MenuModel('Sản phẩm', [], Icons.production_quantity_limits),
    MenuModel('Chi tiết', [], Icons.details),
    MenuModel('Định mức', [], Icons.assignment_turned_in),
    MenuModel('Đơn giá', [], Icons.price_check),
    MenuModel('Công đoạn', [], Icons.settings),
    MenuModel('Khách hàng', [], Icons.people),
  ], Icons.manage_accounts),
];
