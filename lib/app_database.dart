

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'expense_model.dart';

class AppDatabase{
  AppDatabase._();
 static final AppDatabase db = AppDatabase._();
  /// Tables
  static const String EXPENSE_TABLE = "expense";
  static const String USER_TABLE = "users";

  /// Users columns
  static const String COLUMN_USER_ID = "uId";
  static const String COLUMN_USER_NAME = "uName";
  static const String COLUMN_USER_EMAIL = "uEmail";
  static const String COLUMN_USER_PASS = "uPass";

  /// Expense (note) columns
  /// add uid here also
  static const String COLUMN_EXPENSE_ID = "expId";
  static const String COLUMN_EXPENSE_TITLE = "expTitle";
  static const String COLUMN_EXPENSE_DESC = "expDesc";
  static const String COLUMN_EXPENSE_TIMESTAMP = "expTimeStamp";
  static const String COLUMN_EXPENSE_AMT = "expAmt";
  static const String COLUMN_EXPENSE_BALANCE = "expBal";
  static const String COLUMN_EXPENSE_TYPE = "expType"; // 0 = debit, 1 = credit
  static const String COLUMN_EXPENSE_CAT_TYPE = "expCatType";
 Database? database;

 Future<Database> getDb()async{
   if (database != null){
     return database!;
   }else{
    database = await createDb();
    return database!;
   }
 }
 Future<Database> createDb()async{
  var directory = await getApplicationDocumentsDirectory();
  var fullPath = join(directory.path,"expenseDb.db");
  return await openDatabase(fullPath,version: 1,onCreate: (Database db, int version)async{
    await db.execute('''
  CREATE TABLE $EXPENSE_TABLE (
    $COLUMN_EXPENSE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    $COLUMN_EXPENSE_TITLE TEXT,
    $COLUMN_EXPENSE_DESC TEXT,
    $COLUMN_EXPENSE_AMT REAL,
    $COLUMN_EXPENSE_TIMESTAMP TEXT,
    $COLUMN_EXPENSE_TYPE INTEGER,
    $COLUMN_EXPENSE_CAT_TYPE INTEGER,
    $COLUMN_EXPENSE_BALANCE REAL,
    $COLUMN_USER_ID INTEGER
  )
''');
    await db.execute('''
  CREATE TABLE $USER_TABLE (
    $COLUMN_USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    $COLUMN_USER_NAME TEXT,
    $COLUMN_USER_EMAIL TEXT,
    $COLUMN_USER_PASS TEXT
    
  )
''');

  });

 }

 Future<bool> addExpense(ExpenseModel expense)async{
   var db = await getDb();
   int rowEffected = await db.insert(EXPENSE_TABLE, expense.toMap());
   return rowEffected > 0;


 }

 Future<List<ExpenseModel>> fetchExpence()async{
   var db = await getDb();
  var data =  await db.query(EXPENSE_TABLE);
  List<ExpenseModel> expenseList = [] ;
  for (var dataList in data){
    expenseList.add(ExpenseModel.fromMap(dataList));
  }
  return expenseList;
 }

}