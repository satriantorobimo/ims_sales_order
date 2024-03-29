import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_order/features/tab/provider/tab_provider.dart';
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

import 'router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
      ],
      child: MaterialApp(
        title: 'Sales Order',
        theme: ThemeData(primaryColor: primaryColor, fontFamily: 'Jakarta'),
        onGenerateRoute: Routers.generateRoute,
        initialRoute: StringRouterUtil.splashScreenRoute,
      ),
    );
  }
}
