import 'dart:convert';
import 'package:coinmaster/pages/info_page.dart';
import 'package:coinmaster/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HttpService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HttpService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _data()),
    );
  }

  Widget _data() {
    return FutureBuilder<http.Response?>(
      future: _http!.get(
          "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1"),
      builder:
          (BuildContext _context, AsyncSnapshot<http.Response?> _snapshot) {
        if (_snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        } else if (_snapshot.hasError) {
          return Text('Error: ${_snapshot.error}');
        } else if (_snapshot.hasData && _snapshot.data != null) {
          // Decode the JSON response
          List<dynamic> _data = jsonDecode(_snapshot.data!.body);
          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (_context, index) {
              String id = _data[index]['id'];
              String name = _data[index]['name'] ?? 'N/A';
              String currentPrice = _data[index]["current_price"].toString();
              num change = _data[index]["price_change_percentage_24h"];

              return Container(
                decoration:const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.2,color: Colors.white))
                ),
                child: ListTile(
                  leading: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: Image.network(
                      _data[index]["image"].toString(),
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
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  subtitle: Text(
                    "\$ $currentPrice",
                    style: const TextStyle(color: Color.fromRGBO(244, 140, 6, 1)),
                  ),
                  trailing: Text(
                    "${change.toString()}%",
                    style:
                        TextStyle(color: change > 0 ? Colors.green : Colors.red),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext _context) {
                      return InfoPage(id: id);
                    }));
                  },
                ),
              );
            },
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
