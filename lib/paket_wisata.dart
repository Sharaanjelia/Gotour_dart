import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail_paket.dart';

// Halaman Paket Wisata
class PaketWisataScreen extends StatefulWidget {
  const PaketWisataScreen({super.key});

  @override
  State<PaketWisataScreen> createState() => _PaketWisataScreenState();
}

class _PaketWisataScreenState extends State<PaketWisataScreen> {
  List paketList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPaket();
  }

  Future<void> fetchPaket() async {
    setState(() { isLoading = true; });
    final response = await http.get(Uri.parse('http://localhost:8000/api/packages'));
    if (response.statusCode == 200) {
      setState(() {
        paketList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paket Wisata')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: paketList.length,
              itemBuilder: (context, index) {
                final paket = paketList[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: paket['gambar'] != null
                        ? Image.network(paket['gambar'], width: 60, height: 60, fit: BoxFit.cover)
                        : const Icon(Icons.image),
                    title: Text(paket['nama'] ?? '-'),
                    subtitle: Text(paket['excerpt'] ?? ''),
                    trailing: Text('Rp ${paket['harga'] ?? '-'}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPaketScreen(paket: paket),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
