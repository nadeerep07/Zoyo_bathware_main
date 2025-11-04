import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zoyo_bathware/core/models/cart_model.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/core/models/category_model.dart';
import 'package:zoyo_bathware/core/models/purchase_model.dart';
import 'package:zoyo_bathware/features/search_screen/viewmodel/search_viewmodel.dart';
import 'package:zoyo_bathware/features/splash_mode/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  } else {
    Hive.initFlutter();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(PurchaseAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.openBox<Product>('products'); //box opeened
  await Hive.openBox<ProductCategory>('categories');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> SearchViewModel()),
      ],
      child: MaterialApp(
          title: 'Zoyo Bath Ware',
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
          home: Builder(builder: (context) {
          
            return SplashScreen();
          })),
    );
  }
}

