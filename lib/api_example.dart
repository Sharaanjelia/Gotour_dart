import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiExampleScreen extends StatefulWidget {
  const ApiExampleScreen({super.key});

  @override
  ApiExampleScreenState createState() => ApiExampleScreenState();
}

class ApiExampleScreenState extends State<ApiExampleScreen> {
  List<dynamic> apiData = [];
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() { isLoading = true; });
    final response = await http.get(Uri.parse('http://localhost:8000/api/packages'));
    if (response.statusCode == 200) {
      setState(() {
        apiData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() { isLoading = false; });
      showAlert('Gagal mengambil data!');
    }
  }

  Future<void> postData() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/packages'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'nama': 'Paket Baru',
        'harga': 1000000,
        'durasi': '2 Hari 1 Malam',
        'rating': 4.5,
        'excerpt': 'Paket baru dari Flutter',
        'deskripsi': 'Deskripsi paket baru',
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      showAlert('Data berhasil dikirim!');
    } else {
      showAlert('Gagal mengirim data!');
    }
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Info'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API, ListView & Alert')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: fetchData,
                child: Text('GET Data'),
              ),
              ElevatedButton(
                onPressed: postData,
                child: Text('POST Data'),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: apiData.length,
                    itemBuilder: (context, index) {
                      final item = apiData[index];
                      return ListTile(
                        title: Text(item['title'] ?? ''),
                        subtitle: Text(item['body'] ?? ''),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
