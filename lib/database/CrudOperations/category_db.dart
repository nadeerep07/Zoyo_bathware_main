import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';

class CategoryDatabaseHelper {
  static const String categoryBox = 'categories';

  static late Box<Category> _categoryBox;

  static final ValueNotifier<List<Category>> categoriesNotifier =
      ValueNotifier([]);

  /// Initialize Hive Boxes
  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(categoryBox)) {
        _categoryBox = await Hive.openBox<Category>(categoryBox);
      } else {
        _categoryBox = Hive.box<Category>(categoryBox);
      }

      await getAllCategories();
    } catch (e) {
      log('Error initializing boxes: $e');
    }
  }

  /// Add Category
  static Future<void> addCategory(Category category) async {
    if (!Hive.isBoxOpen(categoryBox)) await init();

    try {
      await _categoryBox.put(category.id, category);
      categoriesNotifier.value = [..._categoryBox.values];
      categoriesNotifier.notifyListeners();
    } catch (e) {
      log('Error adding category: $e');
    }
  }

  /// Get All Categories
  static Future<void> getAllCategories() async {
    if (!Hive.isBoxOpen(categoryBox)) await init();

    try {
      categoriesNotifier.value = _categoryBox.values.toList();
      categoriesNotifier.notifyListeners();
    } catch (e) {
      log('Error fetching categories: $e');
    }
  }

  /// Update Category
  static Future<void> updateCategory(
      String categoryId, Category updatedCategory) async {
    if (!Hive.isBoxOpen(categoryBox)) await init();

    try {
      await _categoryBox.put(categoryId, updatedCategory);
      await getAllCategories(); // Reload the categories list
    } catch (e) {
      log('Error updating category: $e');
    }
  }

  static Future<void> deleteCategory(String categoryId) async {
    if (!Hive.isBoxOpen(categoryBox)) await init();

    try {
      await _categoryBox.delete(categoryId);
      await getAllCategories();
    } catch (e) {
      log('Error deleting category: $e');
    }
  }
}
