import 'package:flutter/material.dart';
import 'package:tugas16_flutter/api/api_service.dart';

class AddReservationDialog {
  static Future<bool?> show(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final guestController = TextEditingController();
    final notesController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    bool loading = false;

    Future<void> pickDate(StateSetter setState) async {
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

    Future<void> pickTime(StateSetter setState) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() => selectedTime = picked);
      }
    }

    Future<void> handleReservation(StateSetter setState) async {
      if (!formKey.currentState!.validate() ||
          selectedDate == null ||
          selectedTime == null) {
        return;
      }

      setState(() => loading = true);

      final reservedAt =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')} "
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

      final result = await AuthenticationAPI.createReservation(
        reservedAt: reservedAt,
        guestCount: int.parse(guestController.text),
        notes: notesController.text,
      );

      setState(() => loading = false);

      if (result == "success") {
        Navigator.pop(context, true); // sukses
      } else {
        Navigator.pop(context, false); // gagal
      }
    }

    return showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Tambah Reservasi"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      if (int.tryParse(val) == null) {
                        return "Harus berupa angka";
                      }
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
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => pickDate(setState),
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedTime == null
                              ? "Jam belum dipilih"
                              : "Jam: ${selectedTime!.format(context)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => pickTime(setState),
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: loading ? null : () => handleReservation(setState),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Reservasi"),
            ),
          ],
        ),
      ),
    );
  }
}
