import 'dart:io';

import 'package:combined/Bluetooth/BtPage.dart';
import 'package:combined/WiFi/wifipage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text("Conexiones"),
          centerTitle: true,
          elevation: 25.5,
          titleTextStyle: const TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
      ),
      body:
      const Center(
        child: Text('Diana Cecilia Acosta Murguía, ISC\nDesarrollo de Soluciones móviles del grupo 8AY 19041185\n'
            'Docente: Norma Alicia García Vidaña',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: GNav(
        tabBorderRadius: 35,
        tabActiveBorder: Border.all(color: Colors.purple, width: 3),
        gap: 10,
        iconSize: 30,
        activeColor: Colors.deepPurpleAccent,
        color: Colors.white,
        tabBackgroundColor: Colors.black26, // selected tab background color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // navigation bar padding
        tabs: const [
          GButton(
              icon: Icons.wifi_outlined,
              text: 'WiFi'
          ),
          GButton(
              icon: Icons.home,
              text: 'Home'
          ),
          GButton(
              icon: Icons.bluetooth,
              text: 'Bluetooth'
          )
        ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) async {
          _selectedIndex = index;
          switch (index) {
            case 0: {
              final navigator = Navigator.of(context);
              Socket sock = await Socket.connect('192.168.1.10',80 );
              navigator.push(
                  MaterialPageRoute(builder: (context)
                  {
                    return WifiPage(sock);
                  })
              );
            }
            break;
            case 1: {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)
                  {
                    return HomePage();
                  }));
            }
            break;
            case 2: {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)
                  {
                    return BlueToothPage();
                  }));
            }
            break;
          }
          }
      ),
    );
  }


}