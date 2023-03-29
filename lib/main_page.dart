import 'package:chessapp/chess_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ble = FlutterReactiveBle();
  bool connected = false;
  bool scanning = false;

  int _bottomNavSelectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static final List<Widget> _bottomNavTabs = <Widget>[
    Column(children: [
      Container(
        padding: const EdgeInsets.all(30),
        child: const ChessBoard(),
      ),
      const Text(
        'Chess',
        style: optionStyle,
      ),
    ]),
    const Text(
      'SETTINGS',
      style: optionStyle,
    ),
  ];
  static const _connectedBottomNavItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.gamepad),
      label: 'Chess',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavSelectedIndex = index;
    });
  }

  late QualifiedCharacteristic pingChrc;

  void _findAndConnectToBoard() {
    bool found = false;

    ble.scanForDevices(
        withServices: [Uuid.parse("00000001-502e-4e1d-b821-ae2488aa4202")],
        scanMode: ScanMode.lowLatency).listen((device) {
      if (device.name == "magic-chessboard" && !found) {
        found = true;
        print("Found BLE chessboard");
        ble.connectToDevice(id: device.id).listen((conn) {
          print(conn.connectionState);
          if (conn.connectionState == DeviceConnectionState.connected) {
            print("Connected to board");
            setState(() {
              connected = true;
            });
          }
        }, onError: (Object error) {
          print(error);
          // Handle a possible error
        });
      }
    }, onError: (error) {
      print(error);
    });
  }

  void _prepareBle() {
    ble.statusStream.listen((status) {
      if (status == BleStatus.ready && !scanning) {
        print("BLE is ready");
        _findAndConnectToBoard();
        setState(() {
          scanning = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _prepareBle();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Chess"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: connected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _bottomNavTabs.elementAt(_bottomNavSelectedIndex),
                  ],
                )
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Connect to your Chessboard",
                      style: TextStyle(fontSize: 17)),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        // _findAndConnectToBoard();
                      },
                      child: const Text("Connect"))
                ]),
        ),
        bottomNavigationBar: () {
          if (connected) {
            return BottomNavigationBar(
              items: _connectedBottomNavItems,
              currentIndex: _bottomNavSelectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            );
          }
        }());
  }
}
