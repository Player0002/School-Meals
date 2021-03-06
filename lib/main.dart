import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_food/provider/meals_provider.dart';
import 'package:school_food/provider/school_provider.dart';
import 'package:school_food/provider/search_provider.dart';
import 'package:school_food/provider/swiper_provider.dart';
import 'package:school_food/provider/theme_provider.dart';
import 'package:school_food/provider/user_provider.dart';
import 'package:school_food/screens/search/school_screen.dart';
import 'package:school_food/screens/search/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString("assets/google_fonts/OFL.txt");
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  pref.then((value) {
    runApp(
      ChangeNotifierProvider<ThemeProvider>(
        create: (ctx) {
          int val = value.getInt(kUserTheme);
          return ThemeProvider(val == 1
              ? ThemeMode.system
              : val == 2 ? ThemeMode.light : ThemeMode.dark);
        },
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<ThemeMode> getFuture() async {
    final pref = await SharedPreferences.getInstance();
    int value = pref.getInt(kUserTheme);
    return value == 1
        ? ThemeMode.system
        : value == 2 ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SchoolProvider()),
        ChangeNotifierProvider.value(value: SearchProvider()),
        ChangeNotifierProvider.value(value: MealsProvider()),
        ChangeNotifierProvider.value(value: SwiperProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
      ],
      child: MaterialApp(
        title: '학교 급식',
        debugShowCheckedModeBanner: false,
        themeMode: themeNotifier.getThemeMode(),
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xFFFAFAFA),
          iconTheme: IconThemeData(
            color: textColor,
          ),
          backgroundColor: Colors.white,
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
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: Color(0xFFFFFFFF),
            backgroundColor: Colors.blueAccent,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF303030),
            iconTheme: IconThemeData(
              color: Color(0xFFA0A0A0),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              splashColor: Color(0xFFFFFFFF),
              backgroundColor: Colors.blueAccent.shade700,
            ),
            appBarTheme: AppBarTheme(elevation: 0, centerTitle: true)),
        home: Consumer2<SchoolProvider, ThemeProvider>(
          builder: (ctx, item, item2, _) {
            if (item.status == SchoolEnum.selecting) {
              return Scaffold(body: CircularProgressIndicator());
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
