import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zoyo_bathware/database/cart_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/screens/splash_mode/splash_screen.dart';
import 'package:zoyo_bathware/utilitis/common/screen_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(CartAdapter());
  final productBox = await Hive.openBox<Product>('products'); //box opeened
  await Hive.openBox<Category>('categories');
  runApp(MyApp());
  productBox.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zoyo Bath Ware',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: Builder(builder: (context) {
          ScreenSize().initializeScreenSize(context);
          return SplashScreen();
        }));
  }
}
