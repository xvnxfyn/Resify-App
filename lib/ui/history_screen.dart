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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Riwayat", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Hapus Semua?"),
                  content: const Text("Yakin ingin menghapus seluruh riwayat?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
                    TextButton(onPressed: () async {
                      await DatabaseHelper.instance.deleteAllHistory();
                      Navigator.pop(ctx);
                      setState(() {});
                    }, child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                  ],
                )
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<HistoryModel>>(
        future: DatabaseHelper.instance.getAllHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 10),
              Text("Belum ada riwayat", style: TextStyle(color: Colors.grey[500]))
            ],
          ));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.type == "Resistor" ? Colors.red.shade100 : Colors.blue.shade100,
                    child: Icon(
                      item.type == "Resistor" ? Icons.code : Icons.bolt,
                      color: item.type == "Resistor" ? Colors.red : Colors.blue,
                    ),
                  ),
                  title: Text(item.result, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.input}\n${item.timestamp.substring(0, 16)}", style: const TextStyle(fontSize: 12)),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteHistory(item.id!);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}