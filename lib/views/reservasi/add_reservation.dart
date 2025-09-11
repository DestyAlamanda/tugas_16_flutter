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
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
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
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.people,
                          color: Colors.orange.shade600,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: "Jumlah tamu",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.orange.shade600,
                          width: 2,
                        ),
                      ),
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.note, color: Colors.orange.shade600),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: "Catatan (opsional)",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.orange.shade600,
                          width: 2,
                        ),
                      ),
                    ),
                    // validator: (val) {
                    //   if (val == null || val.isEmpty) {
                    //     return "Jumlah tamu wajib diisi";
                    //   }
                    //   if (int.tryParse(val) == null) {
                    //     return "Harus berupa angka";
                    //   }
                    //   return null;
                    // },
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
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: loading ? null : () => handleReservation(setState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 14,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Tambah Menu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
