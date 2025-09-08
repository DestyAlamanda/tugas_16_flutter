import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';
import 'package:tugas16_flutter/model/reservasi_model.dart';
import 'package:tugas16_flutter/views/add_reservation.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late Future<List<ReservationModel>> futureReservations;

  @override
  void initState() {
    super.initState();
    futureReservations = AuthenticationAPI.getReservations();
  }

  void refreshReservations() {
    setState(() {
      futureReservations = AuthenticationAPI.getReservations();
    });
  }

  void confirmCancel(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Batalkan Reservasi"),
        content: const Text(
          "Apakah Anda yakin ingin membatalkan reservasi ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final result = await AuthenticationAPI.cancelReservation(id);
              if (result == "success") {
                refreshReservations();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reservasi berhasil dibatalkan"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Ya, Batalkan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservasi Saya"),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddReservationPage()),
          );
          if (result == true) refreshReservations();
        },
      ),
      body: FutureBuilder<List<ReservationModel>>(
        future: futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Gagal memuat reservasi: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada reservasi"));
          }

          final reservations = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final r = reservations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.event, color: Colors.orange),
                  title: Text("Tanggal: ${r.reservedAt}"),
                  subtitle: Text("Tamu: ${r.guestCount}\nCatatan: ${r.notes}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => confirmCancel(r.id),
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
