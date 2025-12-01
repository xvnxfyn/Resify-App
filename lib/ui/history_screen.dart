import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../models/history_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  
  // Fungsi untuk menampilkan Dialog Konfirmasi Hapus Semua
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Hapus Semua?",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus riwayat perhitungan? Tindakan ini tidak bisa dibatalkan.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            // Tombol TIDAK
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text(
                "Tidak",
                style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w600),
              ),
            ),
            // Tombol YA, HAPUS
            TextButton(
              onPressed: () async {
                // 1. Hapus data dari database
                await DatabaseHelper.instance.deleteAllHistory();
                
                // 2. Tutup dialog
                if (mounted) Navigator.of(context).pop();
                
                // 3. Update tampilan (Refresh)
                setState(() {});
                
                // 4. Tampilkan notifikasi kecil (SnackBar)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Riwayat berhasil dihapus bersih!"))
                );
              },
              child: Text(
                "Ya, Hapus",
                style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Riwayat", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          // Tombol Hapus Kecil di Atas (Opsional, fungsinya sama dengan yang bawah)
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _showDeleteConfirmationDialog,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<HistoryModel>>(
              future: DatabaseHelper.instance.getAllHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                // Tampilan jika data kosong
                if (snapshot.data!.isEmpty) return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    Text("Belum ada riwayat", style: TextStyle(color: Colors.grey[500]))
                  ],
                ));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.type == "Resistor" ? Colors.green[100] : Colors.blue[100], 
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Icon(
                            item.type == "Resistor" ? Icons.graphic_eq : Icons.bolt, 
                            color: item.type == "Resistor" ? Colors.green : Colors.blue
                          ),
                        ),
                        title: Text(item.result, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "${item.input}\n${item.timestamp.substring(0, 16)}", 
                          style: const TextStyle(fontSize: 12)
                        ),
                        // Tombol Hapus per Item (Juga dikasih konfirmasi biar aman)
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () {
                             // Hapus satu item langsung (atau mau dikasih dialog juga boleh)
                             DatabaseHelper.instance.deleteHistory(item.id!).then((_) => setState((){}));
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Tombol Hapus Semua (Besar di Bawah)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, 
                foregroundColor: Colors.white, 
                minimumSize: const Size(double.infinity, 50), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3
              ),
              // Panggil fungsi dialog tadi saat ditekan
              onPressed: _showDeleteConfirmationDialog,
              child: const Text("Hapus Semua Riwayat", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}