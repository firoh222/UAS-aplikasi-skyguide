import 'package:flutter/material.dart';

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
                          DashboardPage(namaUser: nameController.text),
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
