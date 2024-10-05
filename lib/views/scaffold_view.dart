import 'package:eaecontrol/configs/app_colors.dart';
import 'package:eaecontrol/views/account_view.dart';
import 'package:eaecontrol/views/home_view.dart';
import 'package:eaecontrol/views/resume_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class ScaffoldView extends StatefulWidget {
  const ScaffoldView({super.key});

  @override
  State<ScaffoldView> createState() => _ScaffoldViewState();
}

class _ScaffoldViewState extends State<ScaffoldView> {
  final _listViews = [
    const HomeView(),
    const ResumeView(),
    const AccountView()
  ];

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  int _viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listViews[_viewIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.PAINEL_TEXT_COLOR,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(color: AppColors.PRIMARY_COLOR),
        iconSize: 25,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            label: "Incio",
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: "Resumo",
            icon: Icon(
              Icons.bar_chart_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: "Perfil",
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
        currentIndex: _viewIndex,
        onTap: (value) {
          setState(() {
            _viewIndex = value;
          });
        },
      ),
    );
  }
}
