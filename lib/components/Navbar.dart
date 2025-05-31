import 'package:distribook/constants/index.dart';
import 'package:distribook/screens/LoanRequestScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:distribook/screens/HomeScreen.dart';
import 'package:distribook/screens/SettingScreen.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;

  const Navbar({super.key, this.initialIndex = 0});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex;
  List<Widget> _widgetOptions = <Widget>[];
  String role = "buyer";

  Future<List<Widget>> initMenus() async {
    return <Widget>[
      const HomeScreen(),
      const LoanRequestScreen(),
      const SettingScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initializeMenus();
  }

  void _initializeMenus() async {
    List<Widget> menus = await initMenus();
    setState(() {
      _widgetOptions = menus;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Block the back button press
        return false;
      },
      child: Scaffold(
        backgroundColor: WHITE,
        body: _widgetOptions.isNotEmpty
            ? _widgetOptions[_selectedIndex]
            : Container(),
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book),
                label: 'Buku',
              ),
                BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bookmark),
                label: 'Peminjaman',
              ),
               BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.settings),
                label: 'Pengaturan',
              ),
            ],
            currentIndex: _selectedIndex,
            elevation: 0,
            backgroundColor: WHITE,
            selectedItemColor: GREY,
            unselectedItemColor: SEMIBLACK,
            onTap: _onItemTapped,
            showSelectedLabels: true,
            iconSize: 20,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
