import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UMSHomePage extends StatefulWidget {
  const UMSHomePage({super.key});

  @override
  State<UMSHomePage> createState() => _UMSHomePageState();
}

class _UMSHomePageState extends State<UMSHomePage> {

  late Future<Map<String, dynamic>> users;
  var jsonList;

  void getUsers()  async {
      try{
        final dio = Dio();
        dio.options.headers['Access-Control-Allow-Origin'] = '*';

        final res = await dio.get('http://localhost:3000/api/v1/users');

        if (res.statusCode == 200) {
          final users = res.data;
          // print(data['count']);
          // return data;

          setState(() {
            jsonList = users['data'] as List;
          });
        } else {
          throw 'Failed to get Users Data. Status code: ${res.statusCode}';
        }

      }catch(err){
        print('Try Again ! Error getting User Info. : $err');
        throw err.toString();
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users')
        ),

      body: ListView.builder(

          itemCount : jsonList == null?0 :jsonList.length,
          itemBuilder: (BuildContext context , int index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              child: ListTile(
                leading: ClipRect(
                  child: jsonList[index]['profilePic'] != null
                      ? Image.network(
                    jsonList[index]['profilePic'],
                    width: 50.0, // Adjust the width as needed
                    height: 50.0, // Adjust the height as needed
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    '',
                    width: 50.0, // Adjust the width as needed
                    height: 50.0, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),


                title: Text(jsonList[index]['firstName'] + ' ' + jsonList[index]['lastName']),
                subtitle: Text(jsonList[index]['email']),
              )
            )
          ],
        );
      })
    
    );
  }
}
