import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:sales_order/features/login/data/auth_response_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        uid TEXT,
        name TEXT,
        system_date TEXT,
        branch_code TEXT,
        branch_name TEXT,
        idpp TEXT,
        company_code TEXT,
        company_name TEXT,
        idle_time TEXT,
        is_watermark TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'salesorder.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Insert user
  static Future<void> insertUser(Datalist datalist) async {
    try {
      final db = await DatabaseHelper.db();

      await db.insert('user', datalist.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      await db.close();
    } catch (e) {
      dev.log('Error $e');
    }
  }

  // User Data by ID
  static Future<List<Map<String, dynamic>>> getUserData() async {
    final db = await DatabaseHelper.db();
    return db.query('user', limit: 1);
  }

  // Delete
  static Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete('user', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
