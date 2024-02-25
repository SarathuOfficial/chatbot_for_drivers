import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AlertPage extends StatefulWidget {
  final String name;
  const AlertPage({Key? key, required this.name}) : super(key: key);

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {

  var alertDialog = Container();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:AppBar(
        title:const Text("ALERT"),
      ),
      body : Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:[

            Flexible(
                flex:8,
                child: alertDialog
            ),

            Flexible(
              flex:2,
              child: TextButton(
                onPressed:() async {
                  var json = await FirebaseFirestore.instance.collection('id').doc('doc_id').get();
                  if(json['isNoticed'] == false){

                    var flutterTts = FlutterTts();
                    await flutterTts.setLanguage("en-US");
                    await flutterTts.setSpeechRate(0.4);
                    await flutterTts.setVolume(1.0);
                    await flutterTts.setPitch(1.0);
                    await flutterTts.setVoice({'name' : "Karen", 'locale': 'em-AU'});
                    flutterTts.speak("Hey ${widget.name}, there is an urgent message for you from ${(json['name'] != "") ? json['name'] : "someone"}. The message is that \"${json['msg']}\" ");

                    print(json['name']);
                    print(json['msg']);
                    alertDialog = Container(
                      height : MediaQuery.of(context).size.height * 0.5,
                      width : MediaQuery.of(context).size.width,
                      padding :const EdgeInsets.all(50),
                      alignment: Alignment.center,
                      child:Center(
                        child: Card(
                          child : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "There is an urgent message for you from ${(json['name'] != "") ? json['name'] : "someone"}.\n The message is \"${json['msg']}\" ",
                                      textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed:() async {
                                      await FirebaseFirestore.instance.collection('id').doc('doc_id').set({
                                        'name' : json['name'],
                                        'msg' : json['msg'],
                                        'isNoticed' : true,
                                      });

                                      setState(() {});
                                    },
                                    child:const Text("MARK AS READ"),
                                  ),
                                ],
                              )
                          ),
                          ),
                      ),
                    );
                  }
                  else {
                    alertDialog = Container();
                  }
                  setState(() {});
                },
                child:const Text("TURN ON ALERT MODE (REFRESH) "),
              ),
            )
          ],
        ),
      ),
    );
  }
}
