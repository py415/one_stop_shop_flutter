import 'package:flutter/material.dart';
import 'package:one_stop_shop_flutter/views/screens/orders_screen.dart';
import 'package:provider/provider.dart';

import 'models/cart_provider.dart';
import 'models/products_provider.dart';
import 'models/orders_provider.dart';
import 'views/screens/products_overview_screen.dart';
import 'views/screens/product_detail_screen.dart';
import 'views/screens/cart_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
        )
      ],
      child: MaterialApp(
        title: 'One Stop Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
