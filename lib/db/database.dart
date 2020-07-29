import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/mFav.dart';
import 'package:flutter_onlie_shop/models/mOrder.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';
import 'package:flutter_onlie_shop/models/order.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'my_dao.dart';

part 'database.g.dart'; // the generated code will be there

//flutter packages pub run build_runner build  //need it to database.g.dart generate first time
//flutter packages pub run build_runner watch //need it to always watching

@Database(version: 2, entities: [MCartItem, MOrder, MOrderItem, MFav])
abstract class AppDatabase extends FloorDatabase {
  MyDao get myDao;
}
