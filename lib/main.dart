import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Countries list'),
        centerTitle: true,
        leading: FlutterLogo(),
      ),
      body: HomeCountries()
    )
  ));
}

class MyHttpOverrides extends HttpOverrides{
@override
HttpClient createHttpClient(SecurityContext? context){
  return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
}
}

class HomeCountries extends StatefulWidget {

  @override
  _HomeCountriesState createState() => _HomeCountriesState();
}

class _HomeCountriesState extends State<HomeCountries> {
  //Logic
  List countries = []; //TODO make country interface
  Uri url  = Uri.https('restcountries.com', '/v2/all');

  //init state
  @override
  void initState() {
    getCountries();
  }

  void getCountries() async {
    // 'future'
    Response response = await get(url);

    if (response.statusCode == 200){
      List jsonRespones  = jsonDecode(response.body);
      setState(() {
        countries = jsonRespones;
      });
      //print(jsonRespones); //check if response received
    } else {
      //error
      setState(() {
        countries = [{
          'name' : 'error',
          'capital' : 'error!',
          'flag': ''
        }];
      });
    }
  }
  
  //UI
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: 
          ListView.builder(
            itemCount: countries.length,
            itemBuilder: (BuildContext context, int index){
              return ListTile(
                title: Text(countries[index]['name']),
                subtitle: Text(countries[index]['capital'] != null ? countries[index]['capital'] :'unknown'),
                leading: SvgPicture.network(countries[index]['flag'], width: 40) ,
              );
            },
          )
        )
      ],
    );
  }
}





