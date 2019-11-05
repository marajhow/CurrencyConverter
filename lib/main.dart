import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=f3bf7d92";

void main() async {
  print(await getData());

  http.Response response = await http.get(request);
  print(json.decode(response.body)["results"]["currencies"]["USD"]);

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    )
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController ();
  final dolarController = TextEditingController ();
  final euroController = TextEditingController ();
  final pesoController = TextEditingController ();
  final bitcoinController = TextEditingController ();


  double dolar;
  double euro;
  double peso;
  double bitcoin;

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    pesoController.text = (real/peso).toStringAsFixed(2);
    bitcoinController.text = (real/bitcoin).toStringAsFixed(4);
  }

  void _dolarChanged(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    this.dolar;
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(2);
    bitcoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(4);
  }

  void _euroChanged(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    this.euro;
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(4);
  }

  void _pesoChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double peso = double.parse(text);
    this.peso;
    realController.text = (peso * this.peso).toStringAsFixed(2);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(2);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(2);
    bitcoinController.text = (peso * this.peso / bitcoin).toStringAsFixed(4);
  }

  void _bitcoinChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    this.bitcoin;
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(4);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    pesoController.text = "";
    bitcoinController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Conversor"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando dados...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao carregar dados...",
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                          textAlign: TextAlign.center),
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                    bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                          Divider(),
                          buildTextField("Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dolar", "U\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "€", euroController, _euroChanged),
                          Divider(),
                          buildTextField("Peso ARS", "", pesoController, _pesoChanged),
                          Divider(),
                          buildTextField("Bitcoin", "₿", bitcoinController, _bitcoinChanged),
                          Divider(),
                        ],
                      )
                    );
                  }
              }
            })
    );



     /*
      theme: ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
  )
)
      */
  }
  Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
    return
      TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.amber),
            border: OutlineInputBorder(),
            prefixText: prefix
        ),
        style: TextStyle(
            color: Colors.amber, fontSize: 25.0
        ),
        onChanged: f,
        keyboardType: TextInputType.number,
      );
  }
}
