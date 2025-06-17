import 'package:dribbble_todo/feature/home/presentation/pages/desktop_home_page.dart';
import 'package:dribbble_todo/feature/home/presentation/pages/mobile_home_page.dart';
import 'package:flutter/material.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if(width>=950){
      return DesktopHomePage();
    }else{
      return MobileHomePage();
    }    
  }
}