import 'company.dart';

class Job {
  String location;
  String role;
  Company company;
  String detail;
  bool isFavorite;
  Job(
      {required this.role,
      required this.location,
      required this.company,
      required this.detail,
      this.isFavorite = false});
}
