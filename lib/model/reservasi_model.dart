class ReservationModel {
  final int id;
  final String reservedAt;
  final int guestCount;
  final String notes;

  ReservationModel({
    required this.id,
    required this.reservedAt,
    required this.guestCount,
    required this.notes,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      reservedAt: json['reserved_at'].toString(),
      guestCount: json['guest_count'] is int
          ? json['guest_count']
          : int.parse(json['guest_count'].toString()),
      notes: json['notes']?.toString() ?? "-",
    );
  }
}
