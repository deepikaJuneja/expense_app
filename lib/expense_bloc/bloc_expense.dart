import 'package:expense_app/app_database.dart';
import 'package:expense_app/expense_bloc/expense_events.dart';
import 'package:expense_app/expense_bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocExpense extends Bloc< ExpenseEvent,ExpenseState> {
  BlocExpense({required this.appDb}) : super(InitialState()){
    on<AddExpense>((event, emit)async{
      emit(LoadingState());
     var check = await appDb.addExpense(event.newExpense);
     if (check){
       var mdata = await appDb.fetchExpence();
       emit(LoadedState(expenseData: mdata));
     }else{
       emit (ErrorState(errorMsg: "Data Not added"));
     }
    });
    on<FetchExpense>((event,emit)async {
      emit(LoadingState());
      var fetchdata = await appDb.fetchExpence();
      emit(LoadedState(expenseData: fetchdata));
    });
  }

  AppDatabase appDb;


}