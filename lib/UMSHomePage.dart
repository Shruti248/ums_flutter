import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UMSHomePage extends StatefulWidget {
  const UMSHomePage({super.key});

  @override
  State<UMSHomePage> createState() => _UMSHomePageState();
}

class _UMSHomePageState extends State<UMSHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users')
        ),

      body:  Center(
        child: ListView(
          // scrollDirection: Axis.horizontal,
          // reverse: true,
          children:const [
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('One' , style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Two' , style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text('Three' , style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),),
            ),
            Padding(
              padding:EdgeInsets.all(8.0),
              child: Text('Four' , style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),),
            )

          ],
        ),
      ),
      );
  }
}
