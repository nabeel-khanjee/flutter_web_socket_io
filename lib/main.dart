import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: HomePage(
            channel:
                new IOWebSocketChannel.connect("wss://echo.websocket.org")));
  }
}

class HomePage extends StatefulWidget {
  final WebSocketChannel channel;
  HomePage({this.channel});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Web Socket"),
        ),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Form(
                  child: new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Send Any Massage",
                ),
                controller: editingController,
              )),
              new StreamBuilder(
                  stream: widget.channel.stream,
                  builder: (context, snapshot) {
                    return new Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new Text(
                            snapshot.hasData ? "${snapshot.data}" : ""));
                  })
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.send),
          onPressed: null,
        ));
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.channel.sink.close();
  }
}
