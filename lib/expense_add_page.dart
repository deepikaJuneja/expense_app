import 'package:expense_app/app_constants/category_list.dart';
import 'package:expense_app/expense_bloc/bloc_expense.dart';
import 'package:expense_app/expense_bloc/expense_events.dart';
import 'package:expense_app/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_constants/spaces_padding.dart';

class ExpenseAddPage extends StatefulWidget {
  ExpenseAddPage({super.key, required this.Amount});
num Amount;
  @override
  State<ExpenseAddPage> createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  final TextEditingController expenseNameController = TextEditingController();

  final TextEditingController expenseDescController = TextEditingController();

  final TextEditingController expenseAmountController = TextEditingController();

  List<String> dropDownMenuItem = ["Credit", "Debit"];

  String selectExpenseType = "Credit";
  int selectedExpenseId = -1;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense"), backgroundColor: Colors.cyan),
      body: SingleChildScrollView(
        child: StatePadding(
          childWidget: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              commonTextField(
                hintText: 'Name your expense',
                iconData: Icons.abc,
                textFieldNameController: expenseNameController,
              ),
              SizedBox(height: 30),
              commonTextField(
                hintText: 'Add Desc',
                iconData: Icons.abc,
                textFieldNameController: expenseDescController,
              ),
              SizedBox(height: 30),
              commonTextField(
                hintText: 'Enter Amount',
                iconData: Icons.price_change,
                textFieldNameController: expenseAmountController,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: DropdownButton(
                  value: selectExpenseType,

                  // items: [
                  //   DropdownMenuItem(child: Text("Credit"), value: 1),
                  //   DropdownMenuItem(child: Text("Debit"), value: 2),
                  // ],
                  items: dropDownMenuItem.map((e) {
                    return DropdownMenuItem(child: Text(e), value: e);
                  }).toList(),
                  onChanged: (value) {
                    selectExpenseType = value.toString();
                    setState(() {});
                  },
                ),
              ),
              // DropdownMenu(
              //   onSelected: (value){},
              //
              //   dropdownMenuEntries: [
              //     DropdownMenuEntry(value: 1, label: "Credit"),
              //     DropdownMenuEntry(value: 2, label: "Debit"),
              //   ],
              // ),
              SizedBox(height: 70),
              commonElevatedBtn(
                backgroundColor: Colors.black,
                onPressed: () {
                  showBottomSheet();
                },
                childWidget: selectedExpenseId == -1
                    ? Text(
                        "Choose Expense",
                        style: TextStyle(color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Image.asset(
                            CategoryList
                                .mCategory[selectedExpenseId - 1]
                                .ImagePath,
                          ),
                          SizedBox(width: 10),
                          Text(
                            CategoryList
                                .mCategory[selectedExpenseId - 1]
                                .categoryTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 10),
              commonElevatedBtn(
                backgroundColor: Colors.white,

                onPressed: () {
                  selectDate();
                },
                childWidget: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              commonElevatedBtn(
                backgroundColor: Colors.black,
                onPressed: () {

                 if (selectExpenseType == "Credit"){
                    widget.Amount += double.parse(expenseAmountController.text.toString());
                  print("${widget.Amount}, credit");
                 }else
                   {
                      widget.Amount -= double.parse(expenseAmountController.text.toString());
                      print("${widget.Amount}, debit");
                   }
                  BlocProvider.of<BlocExpense>(context).add(
                    AddExpense(
                      newExpense: ExpenseModel(
                        expenseAmount: double.parse(
                          expenseAmountController.text.toString(),
                        ),
                        expenseBalance: widget.Amount.toDouble(),
                        expenseCatType: selectedExpenseId - 1 ,
                        expenseDesc: expenseDescController.text.toString(),
                        expenseId: 0,
                        expenseTitle: expenseNameController.text.toString(),
                        expenseType: selectExpenseType == "Credit" ? 0 : 1,
                        timeStamp: selectedDate.millisecondsSinceEpoch
                            .toString(),
                      ),
                    ),

                  );
                  Navigator.pop(context);
                },
                childWidget: Text(
                  "Add Expense",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // common Textfield
  Widget commonTextField({
    required String hintText,
    required IconData iconData,
    required TextEditingController textFieldNameController,
  }) {
    return TextField(
      controller: textFieldNameController,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: Icon(iconData),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: Colors.black87),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }

  // common Elevated Button
  Widget commonElevatedBtn({
    required Color backgroundColor,
    required VoidCallback onPressed,
    required Widget childWidget,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      //   showModalBottomSheet(
      //     context: context,
      //     builder: (context) {
      //       return Container(
      //         height: 300,
      //         color: Colors.white,
      //
      //         child: Padding(
      //           padding: const EdgeInsets.all(15.0),
      //           child: GridView.builder(
      //             itemCount: 8,
      //             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //               maxCrossAxisExtent: 80,
      //               mainAxisSpacing: 10,
      //               crossAxisSpacing: 10,
      //               mainAxisExtent: 80,
      //             ),
      //             itemBuilder: (context, item) {
      //               return Container(
      //                 height: 100,
      //                 width: 100,
      //
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(15),
      //                   color: Colors.blueAccent,
      //
      //                 ),
      //                 child: Icon(Icons.ac_unit,size: 35,),alignment: AlignmentDirectional.center,
      //               );
      //             },
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(350, 35),
      ),
      child: childWidget,
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          color: Colors.white,

          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              itemCount: CategoryList.mCategory.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 80,
              ),
              itemBuilder: (context, index) {
                var data = CategoryList.mCategory;
                return InkWell(
                  onTap: () {
                    selectedExpenseId = data[index].categoryId;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 100,
                    width: 100,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue.shade200,
                    ),
                    child: Center(
                      child: Image.asset(
                        data[index].ImagePath,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void selectDate() async {
    var Date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime.now(),
    );
    print(Date!.millisecondsSinceEpoch.toString());
    if (selectedDate != null) {
      selectedDate = Date; //("${Date!.year}/${Date.month}/${Date.day}");
      setState(() {});
    }
  }
}
