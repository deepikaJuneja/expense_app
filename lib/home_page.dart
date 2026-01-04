import 'package:expense_app/expense_model.dart';
import 'package:expense_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_constants/category_list.dart';
import 'expense_add_page.dart';
import 'expense_bloc/bloc_expense.dart';
import 'expense_bloc/expense_events.dart';
import 'expense_bloc/expense_state.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dateTimeFormat = DateFormat.yMd();

  List<DateWiseExpenseModel> dateWise = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlocExpense>(context).add(FetchExpense());
  }

  num totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    // print(MediaQuery.of(context).size.height);
    var mvalue = Provider.of<ThemeProvider>(
      context,
    ).isDark; // listen true already
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense"),
        actions: [
          Switch(
            value: mvalue,
            onChanged: (value) {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).valueChange(value: value);
            },
          ),
        ],
      ),
      body: BlocBuilder<BlocExpense, ExpenseState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return CircularProgressIndicator();
          } else if (state is LoadedState) {
            if (state.expenseData.isNotEmpty) {
              int lastId = -1;
              for (var singleExpense in state.expenseData) {
                if (singleExpense.expenseId > lastId) {
                  // is line me kya hya h
                  lastId = singleExpense.expenseId;
                }
              }
              // print("$lastId , lastId value");
              // print(state.expenseData[0].expenseBalance);
              totalAmount = state.expenseData
                  .firstWhere((e) => e.expenseId == lastId)

                  .expenseBalance;

              // totalAmount =  state.expenseData[lastId-1].expenseBalance;

              // var singleExpense = state.expenseData.last;
              // var lastExpenseAmount = singleExpense.expenseAmount;

              // totalAmount = lastExpenseAmount;
              filterWiseExpense(state.expenseData);
              return orientation == Orientation.portrait
                  ? potraitScreen()
                  : landscape();
            } else {
              return Center(
                child: Text(
                  "No Expense",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              );
            }
          }

          return Container(color: Colors.grey);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseAddPage(Amount: totalAmount),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // filter ki unique date list
  void filterWiseExpense(List<ExpenseModel> allExpense) {
    // list of model me se hi search krege
    dateWise.clear();
    var listUniqueDates = [];
    for (var eachExpense in allExpense) {
      // get dates from model List
      var dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(
          eachExpense.timeStamp,
        ), // convert date into int and send to get millisecondEpoch to get expect date
      );
      var mdate = dateTimeFormat.format(
        dateTime,
      ); // set dateFormat with intl package
      if (!listUniqueDates.contains(mdate)) {
        // check if date is already in list (only unique date)
        listUniqueDates.add(mdate);
      }
    }
    // unique dates ke bad us date ki model list nikalni h date, amount and model list
    for (String eachDate in listUniqueDates) {
      List<ExpenseModel> eachDateExpense = [];
      var totalAmount = 0;
      for (var eachExpense in allExpense) {
        // all expense me se 1 -1 expense model nilkalna h
        var dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(
            eachExpense.timeStamp,
          ), // convert date into int and send to get millisecondEpoch to get expect date
        );
        var date = dateTimeFormat.format(dateTime);
        if (eachDate == date) {
          // agar same date h to list me enter kr do
          eachDateExpense.add(eachExpense);
          // print(eachDateExpense);
          if (eachExpense.expenseType == 0) {
            // if expense type is credit then add expense amount in total Amount
            totalAmount += eachExpense.expenseAmount.toInt();
          } else {
            totalAmount -= eachExpense.expenseAmount
                .toInt(); // else expense type is debit then mimus expense amount from total Amount
          }
        }
      }
      var todayDate = DateTime.now();
      var formattedTodayDate = dateTimeFormat.format(todayDate); // format set
      if (formattedTodayDate == eachDate) {
        // compare today date se each date jo bhi same hoga vo today show krega
        eachDate = "Today";
      }

      var yesterdayDate = DateTime.now().subtract(
        Duration(days: 1),
      ); // this is the way for get date -1
      var formattedyesterdayDate = dateTimeFormat.format(yesterdayDate);
      if (formattedyesterdayDate == eachDate) {
        eachDate = "Yesterday";
      }

      dateWise.add(
        // model me data add kiya h
        DateWiseExpenseModel(
          date: eachDate,
          allTransactionDate: eachDateExpense,
          totalAmount: totalAmount.toString(),
        ),
      );
    }
  }

  Widget commonTotalAmountText() {
    return Center(
      child: Text(
        totalAmount.toString(),
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget potraitScreen() {
    return Column(
      children: [
        Expanded(flex: 1, child: commonTotalAmountText()),

        Expanded(
          flex: 4,
          child: ListView.builder(
            itemCount: dateWise.length,
            itemBuilder: (context, parentindex) {
              var eachItem = dateWise[parentindex];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dateWise[parentindex].date),

                        Text(dateWise[parentindex].totalAmount),
                      ],
                    ),
                    SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: eachItem.allTransactionDate.length,
                      physics: NeverScrollableScrollPhysics(), // scroll ni hoga
                      itemBuilder: (context, childindex) {
                        var data = eachItem.allTransactionDate[childindex];
                        return ListTile(
                          leading: Image.asset(
                            CategoryList
                                .mCategory[data.expenseCatType]
                                .ImagePath,
                          ),
                          trailing: Text(data.expenseAmount.toString()),
                          title: Text(data.expenseTitle),
                        );
                      },
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget landscape() {
    return Row(
      children: [
        Expanded(flex: 1, child: commonTotalAmountText()),

        Expanded(
          flex: 4,
          child: ListView.builder(
            itemCount: dateWise.length,
            itemBuilder: (context, parentindex) {
              var eachItem = dateWise[parentindex];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dateWise[parentindex].date),

                        Text(dateWise[parentindex].totalAmount),
                      ],
                    ),
                    SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: eachItem.allTransactionDate.length,
                      physics: NeverScrollableScrollPhysics(), // scroll ni hoga
                      itemBuilder: (context, childindex) {
                        var data = eachItem.allTransactionDate[childindex];
                        return ListTile(
                          leading: Image.asset(
                            CategoryList
                                .mCategory[data.expenseCatType]
                                .ImagePath,
                          ),
                          trailing: Text(data.expenseAmount.toString()),
                          title: Text(data.expenseTitle),
                        );
                      },
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
