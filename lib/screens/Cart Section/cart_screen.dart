import 'package:flutter/material.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text("Cart"),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                  color: AppColors.primaryColor,
                  onPressed: () {},
                  icon: Icon(Icons.add_shopping_cart_rounded)))
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            elevation: 6,
            child: ListTile(
                leading: Icon(Icons.photo),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SINK"),
                    SizedBox(
                      height: 2,
                    ),
                    Text('ZRP:1000')
                  ],
                )),
          );
        },
      ),
    );
  }
}
