import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/history_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  
// Fungsi Pop-up Konfirmasi Hapus Semua
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Hapus Semua?"),
          content: const Text("Apakah Anda yakin ingin menghapus seluruh riwayat perhitungan? Tindakan ini tidak bisa dibatalkan."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(ctx);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                navigator.pop();
                await DatabaseHelper.instance.deleteAllHistory(); 
                setState(() {}); // Refresh UI
                
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Riwayat berhasil dikosongkan")),
                  );
                }
              },
              child: const Text("Ya, Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<HistoryModel>>(
              future: DatabaseHelper.instance.getAllHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada riwayat"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: item.type == "Resistor" 
                          ? Image.asset(
                              'lib/assets/images/icon_resistor.png',
                              width: 32,
                              height: 32,
                              color: Colors.red.shade600,
                            )
                          : Image.asset(
                              'lib/assets/images/icon_kalkulator.png',
                              width: 32,
                              height: 32,
                              color: Colors.blue.shade700,
                            ),
                        title: Text(item.result, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${item.input}\n${item.timestamp.substring(0, 16)}"),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 223, 17, 17)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text("Hapus Item?"),
                                  content: const Text("Yakin ingin menghapus riwayat ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        await DatabaseHelper.instance.deleteHistory(item.id!);
                                        setState(() {});
                                      },
                                      child: const Text("Ya, Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text("Hapus Semua Riwayat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                _showDeleteConfirmation(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}