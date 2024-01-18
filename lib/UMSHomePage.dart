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
        dio.options.extra['withCredentials'] = true;

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


                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed

                  child: Image.network(
                    (jsonList[index]['profilePic'] != 'undefined' && jsonList[index]['profilePic'] != '')
                        ?'http://localhost:3000/uploads/${jsonList[index]['profilePic']}'
                        : 'assets/defaultProfilePic.jpg',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      // Handle error loading image (e.g., display a placeholder image)
                      return Image.asset(
                        'assets/defaultProfilePic.jpg', // Replace with your placeholder image asset
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      );
                    },
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
