import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/bloc/pages_bloc.dart';
import 'package:socket_io/streamsocket.dart';
import 'package:socket_io/const/const.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class Home extends StatefulWidget {
  Home({Key? key, required this.nickname}) : super(key: key);
  String nickname;
  StreamSocket streamSocket = StreamSocket();
  TextEditingController messageController = TextEditingController();
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController _scrollController;
  late io.Socket socket;
  @override
  void dispose() {
    widget.messageController.dispose();
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

  void _resetTextController() {
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesBloc, PagesState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          socket.disconnect();
          context.read<PagesBloc>().add(GotoJoinPage());
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.blueGrey..shade600,
          body: StreamBuilder<Map<String, dynamic>>(
              stream: widget.streamSocket.getResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  StreamSocket.messages
                      .add(snapshot.data as Map<String, dynamic>);
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
          bottomNavigationBar: _buildBottomNavigationItem(context),
        ),
      );
    });
  }

  Widget _buildBottomNavigationItem(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 70,
      width: width,
      child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: TextField(
            controller: widget.messageController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write message here',
                suffixIcon: IconButton(
                    onPressed: () async {
                      await sendMessage(widget.messageController.text);
                      moveScroll();
                    },
                    icon: const Icon(Icons.send))),
          )),
    );
  }

  Widget _buildChatBox(int index) {
    String sender = StreamSocket.messages[index]["sender"].toString();
    String message = StreamSocket.messages[index]["text"].toString();

    return sender == widget.nickname
        ? _buildThisUserMessage(sender: sender, message: message)
        // ignore: unnecessary_null_comparison
        : sender == null
            ? _buildSeverMessage(message: message)
            : _buildSeverMessage(message: message);
  }

  Widget _buildThisUserMessage(
      {required String sender, required String message}) {
    return Container(
      alignment: const Alignment(1, 0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherUserMessage(
      {required String sender, required String message}) {
    return Container(
      alignment: const Alignment(-1, 0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.amber.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender),
            Text(message),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverMessage({required String message}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(10)),
        child: Text(message),
      ),
    );
  }
}
