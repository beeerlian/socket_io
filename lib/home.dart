import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io/streamsocket.dart';
import 'package:socket_io/const/const.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class Home extends StatefulWidget {
  Home({Key? key, required this.nickname}) : super(key: key);
  String nickname;
  StreamSocket streamSocket = StreamSocket();
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController _scrollController;
  late io.Socket socket;
  @override
  void dispose() {
    _scrollController.dispose();
    widget.streamSocket.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
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
        socket.emit('message', {"text": "${widget.nickname} joined"});
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
    widget.streamSocket.addResponse((data as Map<String, dynamic>));
  }

  void moveScroll() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Map<String, dynamic>>(
          stream: widget.streamSocket.getResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              StreamSocket.messages.add(snapshot.data as Map<String, dynamic>);
              return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: StreamSocket.messages.length,
                itemBuilder: (context, index) {
                  return _buildChatBox(index);
                },
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendMessage("Hai dari user mobile");
          moveScroll();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChatBox(int index) {
    return Container(
      alignment:
          StreamSocket.messages[index]["sender"].toString() == widget.nickname
              ? const Alignment(1, 0)
              // ignore: unnecessary_null_comparison
              : StreamSocket.messages[index]["sender"].toString() == null
                  ? const Alignment(0, 0)
                  : const Alignment(-1, 0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.amber.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamSocket.messages[index]["sender"] != null
                ? Text(StreamSocket.messages[index]["sender"].toString())
                : Container(),
            Text(StreamSocket.messages[index]['text'].toString()),
          ],
        ),
      ),
    );
  }
}
