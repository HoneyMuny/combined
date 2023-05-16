import 'dart:io';

import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {
  late final Socket channel;
  WifiPage(this.channel);

  @override
  MyWifiPage createState(){
    return MyWifiPage();
  }
}
class MyWifiPage extends State<WifiPage>{
  //late Stream stream;

  @override
  Widget build(BuildContext context){
    return  WillPopScope(
        onWillPop: () async{
          widget.channel.flush();
          widget.channel.close();
          return true;
        },
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Conexion WiFi"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: prender ,
                  child: const Text("Prender")),
              ElevatedButton(onPressed: apagar,
                  child: const Text("Apagar")),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  StreamBuilder(
                    stream: widget.channel,
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        Future.delayed(const Duration(seconds: 5), () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error de conexión', style: TextStyle(color: Colors.black),),
                              content: const Text('Conexión perdida'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Regresar'))
                              ],
                            ),
                          );
                        });
                      }
                      if(!snapshot.hasData){
                        return(const Text("No se ha recibido rexto"));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24),
                        child: Text(snapshot.hasData
                            ? '${String.fromCharCodes(snapshot.data!)}' : ''),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
  void prender(){
    widget.channel.write("Prender\n");
  }
  void apagar(){
    widget.channel.write("Apagar\n");
    widget.channel.flush();
    //dispose();
  }
  @override
  void dispose(){
  //widget.channel.flush();
    //widget.channel.close();
    super.dispose();
  }
}