import 'package:expense_app/expense_model.dart';

abstract class ExpenseEvent{}
class AddExpense extends ExpenseEvent{
  ExpenseModel newExpense ;
  AddExpense({required this.newExpense});
}
class FetchExpense extends ExpenseEvent{

}
class UpdateExpense extends ExpenseEvent{
  ExpenseModel updateExpense ;
  UpdateExpense({required this.updateExpense});
}
class DeleteExpense extends ExpenseEvent {
  int expenseID;
  DeleteExpense({required this.expenseID});
}