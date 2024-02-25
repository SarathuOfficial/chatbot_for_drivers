import 'package:flutter/material.dart';
import "actor.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Actor(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String name;
  const MyHomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var messages = [];
  var messageController = TextEditingController();

  void replyBack() async {
    //
    var impWord1 = "urgent";
    var impWord2 = "important";
    var impWord3 = "emergency";
    var impWord4 = "immediate";
    var impWord5 = "critical";
    var impWord6 = "please";

    await Future.delayed(const Duration(seconds: 1));

    if(messages.last['msg'].toLowerCase().contains(impWord1) || messages.last['msg'].toLowerCase().contains(impWord2) || messages.last['msg'].toLowerCase().contains(impWord3) || messages.last['msg'].toLowerCase().contains(impWord4) || messages.last['msg'].toLowerCase().contains(impWord5)  || messages.last['msg'].toLowerCase().contains(impWord6)){


      // sending message to cloud

      await FirebaseFirestore.instance.collection('id').doc("doc_id").set(
          {
            'name':widget.name,
            'msg':messages.last['msg'],
            'isNoticed':false
          }
      );


      messages.add({ "msg": "This important message is intimated to driver", "side" : "bot"});
    }
    else {
      messages.add({ "msg" : " Sorry, the person is driving the car. \n He will catch you later." , "side" : "bot"});
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: const Text("Chatbot"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex:7,
                child: Container(
                  child:ListView.builder(
                    itemCount: messages.length,
                    itemBuilder:(context,index){
                      return Container(
                        alignment: (messages[index]["side"] == "bot") ? Alignment.centerLeft : Alignment.centerRight,
                        child:Container(
                          margin : EdgeInsets.all(10),
                          padding : EdgeInsets.all(15),
                          decoration : BoxDecoration(
                            color:Colors.blue,
                            borderRadius:  (messages[index]['side'] == 'bot') ? const BorderRadius.only(
                              //bottomleft
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ) : const BorderRadius.only(
                              //bottom right
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),

                            ),
                          ),
                          child: Text(
                              messages[index]['msg'],
                            style:const TextStyle(
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                )),
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: TextField(
                controller: messageController,
                style: const TextStyle(
                  color:Colors.black,
                ),
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed:(){
                  messages.add({"msg" : messageController.text , "side" : "person"});
                  messageController.text = "";
                  setState(() {});
                  replyBack();
                },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.lightGreenAccent,
                  )
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(15)),
              //   borderSide: BorderSide(color: Colors.lightGreenAccent, width: 5.0),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.grey, width: 5.0),
              // ),
              hintText: 'Message',
            ),
            )
            ),
          ],
        ),
      ),
    );
  }
}
