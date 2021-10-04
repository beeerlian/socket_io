import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io/streamsocket.dart';
import 'package:socket_io/utils/const.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class Home extends StatefulWidget {
  Home({Key? key, required this.nickname}) : super(key: key);
  String nickname;
  StreamSocket streamSocket = StreamSocket();
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late io.Socket socket;
  @override
  void dispose() {
    widget.streamSocket.dispose();
    super.dispose();
  }

  @override
  void initState() {
    connectToWebscoketServer();
    super.initState();
  }

  connectToWebscoketServer() {
    try {
      socket = io.io(uri, <String, dynamic>{
        'transports': ['websocket'],
        "Upgrade": false
      });

      socket.connect();
      socket.onConnect((data) {
        log("koneksi berhasil");
        socket.emit('join');
        socket.emit('message', {"text": "${socket.id} joined"});
      });

      socket.on('join', (data) => socket.emit('join'));
      socket.on('message', handleMessage);
      socket.on('disconnect', (_) => log('disconnect'));
    } catch (e) {
      log("error : " + e.toString());
    }
  }

  sendMessage(String message) {
    socket.emit("message", {
      "sender": widget.nickname,
      "text": message,
    });
  }

  // Listen to all message events from connected users
  void handleMessage(dynamic data) {
    log(data.toString());
    widget.streamSocket
        .addResponse((data as Map<String, dynamic>)['text'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String>(
          stream: widget.streamSocket.getResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              StreamSocket.messages.add(snapshot.data as String);
              return ListView.builder(
                itemCount: StreamSocket.messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(StreamSocket.messages[index]),
                  );
                },
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendMessage("Hai dari user mobile");
          socket.disconnect();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
