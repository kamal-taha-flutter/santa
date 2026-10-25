import 'package:equatable/equatable.dart';

class Registration extends Equatable {
  const Registration({
    this.id,
    required this.fullName,
    required this.phone,
    required this.governorate,
    required this.district,
    required this.villageStreet,
    required this.businessType,
    this.farmArea = '',
    this.farmAreaUnit = '',
    this.createdAt,
  });

  final int? id;
  final String fullName;
  final String phone;
  final String governorate;
  final String district;
  final String villageStreet;
  final String businessType;
  final String farmArea;
  final String farmAreaUnit;
  final DateTime? createdAt;

  Registration copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? governorate,
    String? district,
    String? villageStreet,
    String? businessType,
    String? farmArea,
    String? farmAreaUnit,
    DateTime? createdAt,
  }) {
    return Registration(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      district: district ?? this.district,
      villageStreet: villageStreet ?? this.villageStreet,
      businessType: businessType ?? this.businessType,
      farmArea: farmArea ?? this.farmArea,
      farmAreaUnit: farmAreaUnit ?? this.farmAreaUnit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    phone,
    governorate,
    district,
    villageStreet,
    businessType,
    farmArea,
    farmAreaUnit,
    createdAt,
  ];
}
