import 'dart:convert';
import 'package:coinmaster/pages/info_page.dart';
import 'package:coinmaster/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class InfoPage extends StatefulWidget {
  final String id;
  const InfoPage({super.key, required this.id});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  double? _deviceHieght;
  double? _deviceWidth;
  HttpService? _http;
  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HttpService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHieght = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: _data(),
        ),
      )),
    );
  }

  Widget _data() {
    return FutureBuilder<http.Response?>(
        future: _http!.get("/coins/${widget.id}"),
        builder:
            (BuildContext _context, AsyncSnapshot<http.Response?> _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (_snapshot.hasError) {
            return Center(child: Text('Error: ${_snapshot.error}'));
          } else if (_snapshot.hasData && _snapshot.data != null) {
            Map<String, dynamic> _data = jsonDecode(_snapshot.data!.body);
            String name = _data["name"].toString();
            String image = _data["image"]["large"].toString();
            String price =
                _data["market_data"]["current_price"]["usd"].toString();
            num change =
                _data["market_data"]["price_change_percentage_24h"];
            String desc = _data["description"]["en"];

            return Column(
              children: [
                _coinName(name),
                _coinImage(image),
                _coinPrice(price, change),
                _coinDescription(desc),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        });
  }

  Widget _coinName(String name) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _deviceHieght! * 0.02),
      width: _deviceWidth! * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            width: _deviceWidth!* 0.55,
            child: Text(
              name.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(244, 140, 6, 1),
            ),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Buy",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          )
        ],
      ),
    );
  }

  Widget _coinImage(String image) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _deviceHieght! * 0.05),
      child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: _deviceWidth! * 0.6, // Dynamic value, so 'const' removed
            minHeight: _deviceHieght! * 0.3,
            maxWidth: _deviceWidth! * 0.6,
            maxHeight: _deviceHieght! * 0.3,
          ),
          child: Image.network(
            image.toString(),
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
          )),
    );
  }

  Widget _coinPrice(String price, num change) {
    return Column(
      children: [
        Text(
          "\$ ${price.toString()}",
          style: const TextStyle(
              color: Color.fromRGBO(244, 140, 6, 1),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "${change.toString()} %",
          style: TextStyle(fontSize: 15,color: change>0 ? Colors.green : Colors.red),
        )
      ],
    );
  }

  Widget _coinDescription(String desc) {
    return Container(
      width: _deviceWidth! * 0.85,
      margin: EdgeInsets.symmetric(vertical: _deviceHieght! * 0.02),
      child: Text(
        desc.toString(),
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
