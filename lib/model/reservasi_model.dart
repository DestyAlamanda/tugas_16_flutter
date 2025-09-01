// To parse this JSON data, do
//
//     final reservationModel = reservationModelFromJson(jsonString);

import 'dart:convert';

ReservationModel reservationModelFromJson(String str) =>
    ReservationModel.fromJson(json.decode(str));

String reservationModelToJson(ReservationModel data) =>
    json.encode(data.toJson());

class ReservationModel {
  DateTime? reservedAt;
  int? guestCount;
  String? notes;

  ReservationModel({this.reservedAt, this.guestCount, this.notes});

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      ReservationModel(
        reservedAt: json["reserved_at"] == null
            ? null
            : DateTime.parse(json["reserved_at"]),
        guestCount: json["guest_count"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
    "reserved_at": reservedAt?.toIso8601String(),
    "guest_count": guestCount,
    "notes": notes,
  };
}
