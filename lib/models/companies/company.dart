import 'package:hive/hive.dart';

part 'company.g.dart';

@HiveType(typeId: 0)
class Company extends HiveObject {
  @HiveField(0)
  final String companyName;
  @HiveField(1)
  final String? einNumber;
  @HiveField(2)
  final String? address;
  @HiveField(3)
  late final String? logoUrl;
  @HiveField(4)
  final String contactNumber;
  @HiveField(5)
  final String? licenseNo;
  @HiveField(6)
  final String? currency;
  @HiveField(7)
  final String? industryName;
  @HiveField(8)
  late final DateTime createdAt;

  Company(
      {required this.companyName,
      this.einNumber,
      this.address,
      this.logoUrl,
      required this.contactNumber,
      this.licenseNo,
      this.currency,
      this.industryName,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'contactNumber': contactNumber,
      'companyName': companyName,
      'currency': currency,
      'logoUrl': logoUrl,
      'einNumber': einNumber,
      'address': address,
      'industryName': industryName,
      'licenseNo': licenseNo,
      'createdAt': createdAt.millisecondsSinceEpoch
    };
  }
}
