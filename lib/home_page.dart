import 'package:expense_app/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'expense_add_page.dart';
import 'expense_bloc/bloc_expense.dart';
import 'expense_bloc/expense_state.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
var dateTimeFormat = DateFormat.yMd();
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Expense"),

      ),
      body: BlocBuilder<BlocExpense,ExpenseState>(builder: (context,state){
        if(state is LoadingState){

        }else if(state is LoadedState){
           filterWiseExpense(state.expenseData);

        } return Container(color:  Colors.grey,);

      }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpenseAddPage()));
      },child: Icon(Icons.add),),

    );

  }

  void filterWiseExpense (List<ExpenseModel> allExpense){
    var listUniqueDates = [];
    for (var eachExpense in allExpense){
     var dateTime =  DateTime.fromMillisecondsSinceEpoch(int.parse(eachExpense.timeStamp));
    var mdate = dateTimeFormat.format(dateTime);
    if(!listUniqueDates.contains(mdate)){
      listUniqueDates.add(mdate);

    }
      print(listUniqueDates);
    }

  }
}

