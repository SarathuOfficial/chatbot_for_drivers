import 'package:chatbot/main.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import 'alertpage.dart';

class Actor extends StatefulWidget {
  const Actor({Key? key}) : super(key: key);

  @override
  State<Actor> createState() => _ActorState();
}

class _ActorState extends State<Actor> {

  int currentlySelected = 1;
  var userName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Choose Actor"),
      ),
      body: Center(
        child: Column(
          children: [
        TextField(
          onChanged: (String? val){
            userName = val!;
          },
        decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: 'User name',
        hintStyle: TextStyle(color: Colors.blue),
      ),
        ),
      DropdownButton(
              hint: const Text("Choose Actor"),
              value : currentlySelected,
              onChanged: (int? val){
                //val = currentlySelected;
                currentlySelected = val!;
                setState(() {});
              },
              items:const [
                DropdownMenuItem(
                  value: 1,
                  child:Text("Driver"),
                ),
                DropdownMenuItem(
                    value : 2,
                    child: Text("Other person")),
              ],
            ),
            TextButton(
              onPressed:(){
                if(currentlySelected == 1) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlertPage(name : userName)) );
                  print("pressed");
                  print(currentlySelected);
                }
                else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(name:userName)) );
                  print("pressed");
                  print(currentlySelected);
                }

              },
              child:const Text("SUBMIT"),
            ),
          ],
        ),
      ),
    );
  }
}
