import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_food/provider/meals_provider.dart';
import 'package:school_food/provider/school_provider.dart';
import 'package:school_food/provider/search_provider.dart';
import 'package:school_food/provider/swiper_provider.dart';
import 'package:school_food/screens/search/school_screen.dart';
import 'package:school_food/screens/search/search_screen.dart';

import 'constants/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SchoolProvider()),
        ChangeNotifierProvider.value(value: SearchProvider()),
        ChangeNotifierProvider.value(value: MealsProvider()),
        ChangeNotifierProvider.value(value: SwiperProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xFFFAFAFA),
          iconTheme: IconThemeData(
            color: textColor,
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: textColor,
            ),
            textTheme: TextTheme(
              bodyText1: GoogleFonts.notoSans(
                color: textColor,
              ),
              bodyText2: GoogleFonts.notoSans(
                color: textColor,
              ),
              headline6: GoogleFonts.notoSans(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
        home: Consumer<SchoolProvider>(
          builder: (ctx, item, _) {
            if (item.status == SchoolEnum.selecting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (item.status == SchoolEnum.end_selecting) {
              return SchoolScreen();
            }
            return SearchScreen();
          },
        ),
      ),
    );
  }
}
/*
Consumer<SchoolProvider>(
          builder: (ctx, item, _) {
            if (item.status == SearchStatus.initialization) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SearchScreen();
          },
        ),
 */
