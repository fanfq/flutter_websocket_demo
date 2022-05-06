import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://list.ws.mytokenapi.com/ticker'),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,

                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                print("resv ${snapshot.data}");
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }else{
      Map<String,dynamic> items = {"ids":[49653,49654,49674,821756256,49655,325277,49658,49656,198462,49685,49735,821711332,821706073,821703501,49664,49669,821764795,156440,325289,49657,9548206,821760987,821688903,821713265,49660,821707932,821707216,821688469,62681,821717033,150597490,49659,49661,49687,7724902,5155722,821751198,49672,821724450,821750190,821724507,821757634,1809636,821728482,821755344,133897711,49668,821758738,821729216,821743889]};
      Map<String,dynamic> reqData = {
        "event":"ticker",
        "params": items
      };
      String json=convert.jsonEncode(reqData);
      //String reqData = "{'event':'ticker','params':{'ids':[49653,49654,49674,821756256,49655,325277,49658,49656,198462,49685,49735,821711332,821706073,821703501,49664,49669,821764795,156440,325289,49657,9548206,821760987,821688903,821713265,49660,821707932,821707216,821688469,62681,821717033,150597490,49659,49661,49687,7724902,5155722,821751198,49672,821724450,821750190,821724507,821757634,1809636,821728482,821755344,133897711,49668,821758738,821729216,821743889]}}";
      print("req ${json}");
      _channel.sink.add(json);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}