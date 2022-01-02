import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str)[0]);

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.departmentId,
    this.departmentName,
    this.facilityId,
    this.facilityName,
    this.studentId,
    this.studentName,
    this.acceptanceYear,
    this.gpa,
    this.phoneNumber,
    this.password,
  });

  int departmentId;
  String departmentName;
  int facilityId;
  String facilityName;
  int studentId;
  String studentName;
  int acceptanceYear;
  double gpa;
  int phoneNumber;
  String password;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    departmentId: json["departmentId"],
    departmentName: json["departmentName"],
    facilityId: json["facilityId"],
    facilityName: json["facilityName"],
    studentId: json["studentId"],
    studentName: json["studentName"],
    acceptanceYear: json["acceptanceYear"],
    gpa: json["gpa"].toDouble(),
    phoneNumber: json["phoneNumber"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "departmentId": departmentId,
    "departmentName": departmentName,
    "facilityId": facilityId,
    "facilityName": facilityName,
    "studentId": studentId,
    "studentName": studentName,
    "acceptanceYear": acceptanceYear,
    "gpa": gpa,
    "phoneNumber": phoneNumber,
    "password": password,
  };
}
