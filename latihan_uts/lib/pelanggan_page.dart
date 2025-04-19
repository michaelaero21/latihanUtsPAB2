// pelanggan_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PelangganPage extends StatefulWidget {
  @override
  _PelangganPageState createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  // ✅ Perbaikan path database sesuai struktur Firebase kamu
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('pelanggan_list');
  List<Map<String, dynamic>> _listPelanggan = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
  try {
    final snapshot = await _dbRef.get();
    final data = snapshot.value;
    print('🔥 Data dari Firebase: $data');

    final List<Map<String, dynamic>> loaded = [];

    if (data != null && data is List) {
      for (var item in data) {
        if (item != null && item is Map) {
          loaded.add({
            'id_pelanggan': item['id_pelanggan'] ?? '-',
            'nama_pelanggan': item['nama_pelanggan'] ?? 'Tanpa Nama',
            'alamat': item['alamat'] ?? '-',
            'nomor_telepon': item['nomor_telepon'] ?? '-',
            'email': item['email'] ?? '-',
            'jenis_pelanggan': item['jenis_pelanggan'] ?? '-',
            'tanggal_bergabung': item['tanggal_bergabung'] ?? '-',
            'status_akun': item['status_akun'] ?? '-',
            'metode_pembayaran': item['metode_pembayaran'] ?? '-',
            'preferensi_pengiriman': item['preferensi_pengiriman'] ?? '-',
          });
        }
      }
    }

    setState(() {
      _listPelanggan = loaded;
      _isLoading = false;
    });
  } catch (error) {
    print('❌ Error membaca data: $error');
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Pelanggan')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _listPelanggan.isEmpty
              ? Center(child: Text('Belum ada data pelanggan.'))
              : ListView.builder(
                  itemCount: _listPelanggan.length,
                  itemBuilder: (context, index) {
                    final pelanggan = _listPelanggan[index];
                    final id = pelanggan['id_pelanggan'] ?? '-';
                    final nama = pelanggan['nama_pelanggan'] ?? 'Tanpa Nama';
                    final email = pelanggan['email'] ?? '-';
                    final telepon = pelanggan['nomor_telepon'] ?? '-';
                    final status = pelanggan['status_akun'] ?? '-';
                    final alamat = pelanggan['alamat'] ?? '-';
                    final jenis = pelanggan['jenis_pelanggan'] ?? '-';
                    final tanggal = pelanggan['tanggal_bergabung'] ?? '-';
                    final metodePembayaran = pelanggan['metode_pembayaran'] ?? '-';
                    final preferensiPengiriman = pelanggan['preferensi_pengiriman'] ?? '-';

                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text('$id - $nama'),
                      subtitle: Text(
                        '$email | $telepon\nStatus: $status\n$alamat\nJenis: $jenis\nTanggal Bergabung: $tanggal\nMetode Pembayaran: $metodePembayaran\nPreferensi Pengiriman: $preferensiPengiriman',
                        style: TextStyle(fontSize: 12),
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
    );
  }
}