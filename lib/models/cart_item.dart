import 'package:uuid/uuid.dart';
import 'hairdresser.dart';
import 'service_item.dart';

class CartItem {
  final String id;
  final Hairdresser hairdresser;
  final ServiceItem service;
  final DateTime appointmentDate;
  final String appointmentTime;

  CartItem({
    String? id,
    required this.hairdresser,
    required this.service,
    required this.appointmentDate,
    required this.appointmentTime,
  }) : id = id ?? const Uuid().v4();
}
