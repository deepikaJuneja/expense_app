import 'package:expense_app/app_database.dart';

class DateWiseExpenseModel { // Home screen ke liye
  String date;
  String totalAmount;
  List<ExpenseModel> allTransactionDate;
  DateWiseExpenseModel({
    required this.date,
    required this.allTransactionDate,
    required this.totalAmount,
  });
}

class ExpenseModel {
  int expenseId;
  String expenseTitle;
  String expenseDesc;
  String timeStamp;
  double expenseAmount;
  double expenseBalance;
  int expenseType;
  int expenseCatType;
  // int userId;
  ExpenseModel({
    required this.expenseAmount,
    required this.expenseBalance,
    required this.expenseCatType,
    required this.expenseDesc,
    required this.expenseId,
    required this.expenseTitle,
    required this.expenseType,
    required this.timeStamp,
    // required this.userId,
  });
  factory ExpenseModel.fromMap(Map<String, dynamic> mapData) {
    return ExpenseModel(
      expenseAmount: mapData[AppDatabase.COLUMN_EXPENSE_AMT],
      expenseBalance: mapData[AppDatabase.COLUMN_EXPENSE_BALANCE],
      expenseCatType: mapData[AppDatabase.COLUMN_EXPENSE_CAT_TYPE],
      expenseDesc: mapData[AppDatabase.COLUMN_EXPENSE_DESC],
      expenseId: mapData[AppDatabase.COLUMN_EXPENSE_ID],
      expenseTitle: mapData[AppDatabase.COLUMN_EXPENSE_TITLE],
      expenseType: mapData[AppDatabase.COLUMN_EXPENSE_TYPE],
      timeStamp: mapData[AppDatabase.COLUMN_EXPENSE_TIMESTAMP],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      AppDatabase.COLUMN_EXPENSE_TYPE: expenseType,
      AppDatabase.COLUMN_EXPENSE_AMT: expenseAmount,
      AppDatabase.COLUMN_EXPENSE_TITLE: expenseTitle,

      AppDatabase.COLUMN_EXPENSE_DESC: expenseDesc,
      AppDatabase.COLUMN_EXPENSE_CAT_TYPE: expenseCatType,
      AppDatabase.COLUMN_EXPENSE_BALANCE: expenseBalance,
      AppDatabase.COLUMN_EXPENSE_TIMESTAMP: timeStamp,
    };
  }
}
