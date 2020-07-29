import 'package:floor/floor.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/mFav.dart';
import 'package:flutter_onlie_shop/models/mOrder.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';
import 'package:flutter_onlie_shop/models/order.dart';

@dao
abstract class MyDao {
  @Query('SELECT * FROM MCartItem')
  Future<List<MCartItem>> getCartItems();

  @Query('SELECT * FROM MOrder')
  Future<List<MOrder>> getOrders();

  @Query('SELECT * FROM MOrder WHERE id = :id')
  Stream<MOrder> getOrderById(int id);

//  @Query('SELECT * FROM Order')
//  Future<List<Order>> getOrdersTest();

  @Query('SELECT id FROM MCartItem')
  Future<List<MCartItem>> getCartItemsID();

  @Query('SELECT * FROM MFav')
  Future<List<MFav>> getFav();

  @Query('SELECT * FROM MCartItem WHERE id = :id')
  Stream<MCartItem> getCartById(int id);

  @Query('SELECT * FROM MOrderItem WHERE parenId = :id')
  Future<List<MOrderItem>> getOrderItems(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCart(MCartItem mCartItem);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOrder(MOrder mOrder);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveOrderItem(MOrderItem mOrderItem);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> saveFav(MFav mFav);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertOrderItem(List<MOrderItem> mOrderItems);

//  @Insert(onConflict: OnConflictStrategy.replace)
//  Future<void> saveOrderTest(Order order);

  @Query('DELETE FROM MCartItem WHERE id = :id')
  Future<MCartItem> deleteCart(int id);

  @Query('DELETE FROM MCartItem')
  Future<MCartItem> deleteCartAll();

  @Query('DELETE FROM MFav WHERE id = :id')
  Future<MFav> deleteFav(int id);

  @Query('DELETE FROM MFav')
  Future<MFav> deleteAllFav();
}
