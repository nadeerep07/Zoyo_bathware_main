import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';

const String categoryBox = 'categories';
late Box<Category> _categoryBox;

final ValueNotifier<List<Category>> categoriesNotifier = ValueNotifier([]);
bool _isInitialized = false;

Future<void> init() async {
  if (_isInitialized) return;

  try {
    if (!Hive.isBoxOpen(categoryBox)) {
      _categoryBox = await Hive.openBox<Category>(categoryBox);
    } else {
      _categoryBox = Hive.box<Category>(categoryBox);
    }
    _isInitialized = true;
    await getAllCategories();
  } catch (e) {
    log('Error initializing boxes: $e');
  }
}

/// Add Category
Future<void> addCategory(Category category) async {
  if (!_isInitialized) await init();

  try {
    await _categoryBox.put(category.id, category);
    categoriesNotifier.value = [..._categoryBox.values];
    categoriesNotifier.notifyListeners();
  } catch (e) {
    log('Error adding category: $e');
  }
}

/// Get All Categories
Future<void> getAllCategories() async {
  if (!_isInitialized) await init();

  try {
    categoriesNotifier.value = _categoryBox.values.toList();
    categoriesNotifier.notifyListeners();
  } catch (e) {
    log('Error fetching categories: $e');
  }
}

/// Update Category
Future<void> updateCategory(String categoryId, Category updatedCategory) async {
  if (!_isInitialized) await init();

  try {
    await _categoryBox.put(categoryId, updatedCategory);
    await getAllCategories();
  } catch (e) {
    log('Error updating category: $e');
  }
}

/// Delete Category
Future<void> deleteCategory(String categoryId) async {
  if (!_isInitialized) await init();

  try {
    await _categoryBox.delete(categoryId);
    await getAllCategories();
  } catch (e) {
    log('Error deleting category: $e');
  }
}
