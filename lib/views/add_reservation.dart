import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({super.key});

  @override
  State<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final guestController = TextEditingController();
  final notesController = TextEditingController();
  DateTime? selectedDate;
  bool loading = false;

  void pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year, now.month + 3),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void handleReservation() async {
    if (!_formKey.currentState!.validate() || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Isi semua data & pilih tanggal"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reservedAt =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    final result = await AuthenticationAPI.createReservation(
      reservedAt: reservedAt,
      guestCount: int.parse(guestController.text),
      notes: notesController.text,
    );

    setState(() => loading = false);

    if (!mounted) return;
    if (result == "success") {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reservasi berhasil dibuat"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Reservasi"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: guestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah Tamu",
                  prefixIcon: Icon(Icons.people),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Jumlah tamu wajib diisi";
                  }
                  if (int.tryParse(val) == null) return "Harus berupa angka";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: "Catatan",
                  prefixIcon: Icon(Icons.note_alt),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "Tanggal belum dipilih"
                          : "Tanggal: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickDate,
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: const Text(
                      "Pilih Tanggal",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: loading ? null : handleReservation,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Buat Reservasi",
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
