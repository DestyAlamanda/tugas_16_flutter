import 'package:flutter/material.dart';
import 'package:tugas16_flutter/model/menu_model.dart';

class DetailMenu extends StatefulWidget {
  final MenuModel menu;
  const DetailMenu({super.key, required this.menu});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
