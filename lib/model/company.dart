import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String? id;
  final String nameA;
  final String nameE;
  final String addressA;
  final String addressE;
  final String logo;

  const Company({
    this.id,
    required this.nameA,
    required this.nameE,
    required this.addressA,
    required this.addressE,
    required this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      nameA: json['nameA'],
      nameE: json['nameE'],
      addressA: json['AddressA'],
      addressE: json['AddressE'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameA': nameA,
      'nameE': nameE,
      'AddressA': addressA,
      'AddressE': addressE,
      'logo': logo,
    };
  }

  Company copyWith({
    String? nameA,
    String? nameE,
    String? addressA,
    String? addressE,
    String? logo,
  }) {
    return Company(
      id: id,
      nameA: nameA ?? this.nameA,
      nameE: nameE ?? this.nameE,
      addressA: addressA ?? this.addressA,
      addressE: addressE ?? this.addressE,
      logo: logo ?? this.logo,
    );
  }

  @override
  List<Object?> get props => [id, nameA, nameE, addressA, addressE, logo];
}