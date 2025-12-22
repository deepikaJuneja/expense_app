import 'package:expense_app/expense_model.dart';

abstract class ExpenseState {}

class InitialState extends ExpenseState {}

class LoadingState extends ExpenseState {}

class LoadedState extends ExpenseState {
  List<ExpenseModel> expenseData;
  LoadedState({required this.expenseData});
}

class ErrorState extends ExpenseState {
  String errorMsg;
  ErrorState({required this.errorMsg});
}
