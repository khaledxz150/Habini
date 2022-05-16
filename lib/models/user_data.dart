import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str)[0]);

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.departmentId,
    this.facilityId,
    this.studentId,
    this.phoneNumber,
  });

  int departmentId;
  int facilityId;
  int studentId;
  int phoneNumber;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        departmentId: json["departmentId"],
        facilityId: json["facilityId"],
        studentId: json["studentId"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "departmentId": departmentId,
        "facilityId": facilityId,
        "studentId": studentId,
        "phoneNumber": phoneNumber,
      };
}
