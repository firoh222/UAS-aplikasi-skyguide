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
                          DashboardFinalPage(namaUser: nameController.text),
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
    List<String> hari = [
      "Senin",
      "Selasa",
      "Rabu",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];
    List<String> bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    DateTime waktu = DateTime.now();
    String tanggalLengkap =
        "${hari[waktu.weekday - 1]}, ${waktu.day} ${bulan[waktu.month - 1]} ${waktu.year}";

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
            Text(tanggalLengkap, style: const TextStyle(fontSize: 16)),
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

class DashboardFinalPage extends StatefulWidget {
  final String namaUser;
  const DashboardFinalPage({super.key, required this.namaUser});

  @override
  State<DashboardFinalPage> createState() => _DashboardFinalPageState();
}

class _DashboardFinalPageState extends State<DashboardFinalPage>
    with SingleTickerProviderStateMixin {
  String suhu = "...";
  String kondisi = "Memuat data...";
  double ukuranIkon = 100;
  late AnimationController _controller;
  late Animation<double> _animation;
  // Tambahkan controller untuk menangkap ketikan nama kota
  final TextEditingController _kotaController = TextEditingController();

  // 1. LOGIKA SARAN ASLI (Dinamis sesuai suhu)
  String ambilSaran(String suhuTeks) {
    double nilaiSuhu = double.tryParse(suhuTeks.replaceAll('°C', '')) ?? 0;
    if (nilaiSuhu > 30)
      return "Cuaca panas! Jangan lupa minum air putih dan pakai sunblock.";
    if (nilaiSuhu > 20)
      return "Cuaca sangat nyaman untuk jalan-jalan atau olahraga!";
    if (nilaiSuhu == 0) return "Menunggu data...";
    return "Cuaca dingin, pastikan pakai jaket yaaa!";
  }

  IconData ambilIkon(String teksKondisi) {
    if (teksKondisi.contains("Cerah")) return Icons.wb_sunny;
    if (teksKondisi.contains("Hujan")) return Icons.thunderstorm;
    return Icons.cloud;
  }

  Color ambilWarna(String suhuTeks) {
    double nilaiSuhu = double.tryParse(suhuTeks.replaceAll('°C', '')) ?? 0;
    return nilaiSuhu > 30 ? Colors.orangeAccent : Colors.lightBlueAccent;
  }

  // 2. FUNGSI AMBIL DATA CUACA
  Future<void> ambilDataCuaca() async {
    // Latitude & Longitude Pamekasan (Default)
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
        suhu = "29°C"; // Cadangan jika internet bermasalah
        kondisi = "Cerah Berawan";
      });
    }
  }

  Color tentukanWarnaWaktu() {
    int jam = DateTime.now().hour;
    if (jam >= 5 && jam < 15) return Colors.lightBlueAccent;
    if (jam >= 15 && jam < 18) return Colors.orangeAccent;
    return const Color(0xFF1A237E);
  }

  @override
  void initState() {
    super.initState();
    ambilDataCuaca();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 100,
      end: 115,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> hari = [
      "Senin",
      "Selasa",
      "Rabu",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];
    List<String> bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    DateTime waktu = DateTime.now();
    String tanggalLengkap =
        "${hari[waktu.weekday - 1]}, ${waktu.day} ${bulan[waktu.month - 1]} ${waktu.year}";

    return Scaffold(
      backgroundColor: tentukanWarnaWaktu(),
      appBar: AppBar(
        title: const Text("SkyGuide v0.4"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Agar tidak error saat keyboard muncul
        child: Column(
          children: [
            SizedBox(height: 20),
            // 3. FITUR PENCARIAN (Ketik Manual Bagian Ini)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _kotaController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Masukkan nama kota...",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) =>
                    ambilDataCuaca(), // Berfungsi saat tekan enter
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Halo, ${widget.namaUser}!",
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            Text(
              tanggalLengkap,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 10),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Icon(
                  ambilIkon(kondisi),
                  size: _animation.value,
                  color: Colors.white,
                );
              },
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: (_animation.value - 100) / 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.circle,
                          size: 4,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Text(
              suhu,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.black26,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
            ),
            Text(
              kondisi,
              style: const TextStyle(fontSize: 22, color: Colors.white70),
            ),

            const SizedBox(height: 30),
            // 4. TAMPILAN SARAN AKTIVITAS (Logika Asli)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "💡 Saran Aktivitas:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ambilSaran(suhu),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _itemRamalan("Sen", Icons.wb_sunny, "29°"),
                  _itemRamalan("Sel", Icons.cloud, "27°"),
                  _itemRamalan("Rab", Icons.water_drop, "25°"),
                  _itemRamalan("Kam", Icons.thunderstorm, "24"),
                  _itemRamalan("jum", Icons.wb_cloudy, "26°"),
                  _itemRamalan("Sab", Icons.cloud_queue, "28°"),
                  _itemRamalan("Min", Icons.wb_sunny, "30°"),
                ],
              ),
            ), // Baris 464: Penutup SingleChildScrollView (Ramalan)
          ], // Baris 465: Penutup Column Utama
        ), // Baris 466: Penutup SingleChildScrollView (Layar Utama)
      ), // Baris 467: Penutup Container (BACKGROUND WARNA BALIK!)
    ); // Baris 468: Penutup Scaffold
  } // Baris 469: Penutup fungsi build

  Widget _itemRamalan(String hari, IconData ikon, String suhu) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            hari,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Icon(ikon, color: Colors.white, size: 30),
          const SizedBox(height: 12),
          Text(
            suhu,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
