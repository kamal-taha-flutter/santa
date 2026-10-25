import '../../domain/entities/registration.dart';

class RegistrationModel extends Registration {
  const RegistrationModel({
    super.id,
    required super.fullName,
    required super.phone,
    required super.governorate,
    required super.district,
    required super.villageStreet,
    required super.businessType,
    super.farmArea,
    super.farmAreaUnit,
    super.createdAt,
  });

  factory RegistrationModel.fromMap(Map<String, Object?> map) {
    DateTime? createdAt;
    final createdAtValue = map['created_at'];
    if (createdAtValue is String && createdAtValue.isNotEmpty) {
      createdAt = DateTime.tryParse(createdAtValue);
    } else if (createdAtValue is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
    }

    return RegistrationModel(
      id: map['id'] as int?,
      fullName: (map['full_name'] as String? ?? '').trim(),
      phone: (map['phone'] as String? ?? '').trim(),
      governorate: (map['governorate'] as String? ?? '').trim(),
      district: (map['district'] as String? ?? '').trim(),
      villageStreet: (map['village_street'] as String? ?? '').trim(),
      businessType: (map['business_type'] as String? ?? '').trim(),
      farmArea: (map['farm_area'] as String? ?? '').trim(),
      farmAreaUnit: (map['farm_area_unit'] as String? ?? '').trim(),
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName.trim(),
      'phone': phone.trim(),
      'governorate': governorate.trim(),
      'district': district.trim(),
      'village_street': villageStreet.trim(),
      'business_type': businessType.trim(),
      'farm_area': farmArea.trim(),
      'farm_area_unit': farmAreaUnit.trim(),
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory RegistrationModel.fromEntity(Registration entity) {
    return RegistrationModel(
      id: entity.id,
      fullName: entity.fullName,
      phone: entity.phone,
      governorate: entity.governorate,
      district: entity.district,
      villageStreet: entity.villageStreet,
      businessType: entity.businessType,
      farmArea: entity.farmArea,
      farmAreaUnit: entity.farmAreaUnit,
      createdAt: entity.createdAt,
    );
  }
}
