import 'dart:convert';
import 'User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

const titleStyle = TextStyle(fontSize: 20);
const subtitleStyle = TextStyle(fontSize: 18);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final url = Uri.parse("https://reqres.in/api/users");
  var counter;
  var userresult;

  Future<dynamic> callUser() async{
    try{
      final response = await http.get(url);
      if(response.statusCode == 200){
        var result = userFromJson(response.body);
        print(result.data[0].avatar);
        print(result.data[0].email);
        print(result.data[0].firstName);
        print(result.data[0].lastName);
        if(mounted){
          setState(() {
            counter = result.data.length;
            userresult = result;
          });
          return result;
        }
      }
      else{
        print(response.statusCode);
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callUser();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Personel Listesi'),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: counter != null ?
          ListView.builder(
              itemCount: counter,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userresult.data[index].firstName + ' ' + userresult.data[index].lastName,style: titleStyle,),
                  subtitle: Text(userresult.data[index].email,style: subtitleStyle,),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userresult.data[index].avatar),
                    backgroundColor: Colors.orange,
                  ),
                );
              }) : Center(child: CircularProgressIndicator())
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange,child: Icon(Icons.refresh),onPressed: (){
          callUser();
        },),
      ),
    );
  }
}
