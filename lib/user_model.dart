import 'package:expense_app/app_database.dart';

class UserModel {
  String userName;
  String userEmail;
  String userPass;
  int userId;
  UserModel({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userPass,
  });
  factory UserModel.fromMap(Map<String, dynamic> mapData) {
    return UserModel(
      userEmail: mapData[AppDatabase.COLUMN_USER_EMAIL],
      userId: mapData[AppDatabase.COLUMN_USER_ID],
      userName: mapData[AppDatabase.COLUMN_USER_NAME],
      userPass: mapData[AppDatabase.COLUMN_USER_PASS],
    );
  }
  Map<String, dynamic> toMap(){
    return {
      AppDatabase.COLUMN_USER_PASS: userPass,
      AppDatabase.COLUMN_USER_NAME:userName,
      // AppDatabase.COLUMN_USER_ID:userId,
      AppDatabase.COLUMN_USER_EMAIL:userEmail,
    };
}
}
