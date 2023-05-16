import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart";
import "SelectBondedDevicePage.dart";
import 'ChatPage.dart';
class BlueToothPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return  MyBtPage();
  }

}

class MyBtPage extends State<BlueToothPage>
{
  BluetoothState _bluetoothState=BluetoothState.UNKNOWN;
  String _address= "..." ;
  String _name= "..." ;
  Timer? _discoverableTimeoutTimer;
  int _discoverableTiemoutSecondsLeft=0;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState=state;
      });
    });
      Future.doWhile(() async{
        if((await FlutterBluetoothSerial.instance.isEnabled)?? false)
        {
          return false;
        }
        await Future.delayed(Duration(milliseconds: 0xDD));
        return true;
      }).then((_){
        FlutterBluetoothSerial.instance.address.then((address){
          setState(() {
            _address=address!;
          });
        });
      });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name=name!;
      });
    });
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState=state;
        _discoverableTimeoutTimer=null;
        _discoverableTiemoutSecondsLeft=0;
      });
    });
  }
  @override
  void dispose(){
  FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
  _discoverableTimeoutTimer?.cancel();
  super.dispose();
  }
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Conexión BT"),
      ),
      body: Container(
        child: ListView(
        children: <Widget>[
          ListTile(
            title: ElevatedButton(
              child: Text("Ver dispositivos"),
              onPressed: () async{
                final BluetoothDevice? selectedDevice=
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return const SelectBondedDevicePage(
                          checkAvailability: false);
                      }
                      )
                    );
                if(selectedDevice != null){
                  print("Connect->Selected "+selectedDevice.address);
                  _startChat(context,selectedDevice);
                }else{
                  print("Connect->Selected: NONE");
                }
              },

            ),
          )
        ],
        ),
      ),
    );
  }
  void _startChat(BuildContext context, BluetoothDevice server){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context){
        return ChatPage(server: server);
        }
      )
    );
  }
}