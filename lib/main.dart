import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const SkyGuide());

class SkyGuide extends StatelessWidget {
  const SkyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud, size: 80, color: Colors.white),
            const Text(
              "SkyGuide v0.1",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Masukkan Nama Kamu",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Nanti kodingan pindah halaman (Minggu 2) ditaruh di sini
                if (nameController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardRealtimePage(namaUser: nameController.text),
                    ),
                  );
                }
              },
              child: const Text("Masuk"),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String namaUser;
  const DashboardPage({super.key, required this.namaUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SkyGuide Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Halo, $namaUser!", style: const TextStyle(fontSize: 22)),
            const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
            const Text(
              "32°C",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text("Cerah Berawan"),
          ],
        ),
      ),
    );
  }
}

class DashboardRealtimePage extends StatefulWidget {
  final String namaUser;
  const DashboardRealtimePage({super.key, required this.namaUser});

  @override
  State<DashboardRealtimePage> createState() => _DashboardRealTimePageState();
}

class _DashboardRealTimePageState extends State<DashboardRealtimePage> {
  String suhu = "...";
  String kondisi = "Mengambil data...";

  Future<void> ambilDataCuaca() async {
    // koordinat Pamekasan: -7.15, 113.48
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=-7.15&longitude=113.48&current_weather=true",
    );

    try {
      final respon = await http.get(url);
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        setState(() {
          suhu = "${data['current_weather']['temperature']}°C";
          kondisi = "Cerah Berawan";
        });
      }
    } catch (e) {
      setState(() {
        kondisi = "Gagal mengambil data";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ambilDataCuaca();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SkyGuide Real-Time"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Halo, ${widget.namaUser}!",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.cloud_queue, size: 100, color: Colors.blue),
            Text(
              suhu,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            Text(kondisi, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: ambilDataCuaca,
              icon: const Icon(Icons.refresh),
              label: const Text("Update Cuaca"),
            ),
          ],
        ),
      ),
    );
  }
}
