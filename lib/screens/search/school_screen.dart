import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/provider/meals_provider.dart';
import 'package:school_food/provider/school_provider.dart';
import 'package:school_food/provider/swiper_provider.dart';
import 'package:school_food/screens/search/components/graph.dart';
import 'package:school_food/screens/search/information_screen.dart';
import 'package:school_food/screens/search/search_screen.dart';
import 'package:school_food/screens/search/setting_screen.dart';
import 'package:school_food/services/sizeconfig.dart';

class SchoolScreen extends StatelessWidget {
  final weeks = ['월', '화', '수', '목', '금', '토', "일"];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final titles = ["아침", "점심", "저녁"];
    final swiper_provider = Provider.of<SwiperProvider>(context, listen: false);
    final provider = Provider.of<SchoolProvider>(context, listen: false);
    final meal = Provider.of<MealsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      meal.loadingFood(provider.selectedSchool);
    });
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => SearchScreen())),
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              final now = DateTime.now();
              DatePicker.showDatePicker(
                context,
                locale: LocaleType.ko,
                onConfirm: (date) {
                  meal.time = date;
                  meal.loadingFood(provider.selectedSchool);
                },
                currentTime: meal.time,
                minTime: DateTime(now.year, 1, 1),
                maxTime: DateTime(now.year, now.month,
                    DateTime(now.year, now.month + 1, 0).day),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.calendar_today),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => SettingScreen(),
            ),
          );
        },
        child: Icon(Icons.settings),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                ),
                child: Text(
                  "${provider.selectedSchool.school_name}",
                  maxLines: 1,
                  style: defaultFont.copyWith(fontSize: 24),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
                child: Consumer<MealsProvider>(
                  builder: (ctx, item, _) => Text(
                    "${item.time.year}년 ${item.time.month}월 ${item.time.day}일 [ ${weeks[item.time.weekday - 1]} ]",
                    style: defaultFont,
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(200),
                child: GestureDetector(
                  onTap: () {
                    final swi =
                        Provider.of<SwiperProvider>(context, listen: false);
                    swi.isShowAll = !swi.isShowAll;
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Consumer<MealsProvider>(
                      builder: (ctx, i, _) {
                        if (i.status == MealsEnum.food_searching)
                          return CircularProgressIndicator();
                        if (i.status == MealsEnum.error_food_searching)
                          return Center(child: Text("급식을 찾을 수 가 없습니다."));
                        return Consumer<SwiperProvider>(
                          builder: (ctx, item, _) {
                            double value = 0;
                            if (!i.meals.isEmpty(item.index))
                              value = double.parse(i.meals
                                  .getFromIdx(item.index)
                                  .cal
                                  .replaceAll(" Kcal", ""));
                            if (item.isShowAll) {
                              value = 0;
                              for (int idx = 0; idx < 3; idx++) {
                                if (!i.meals.isEmpty(idx))
                                  value += double.parse(i.meals
                                      .getFromIdx(idx)
                                      .cal
                                      .replaceAll(" Kcal", ""));
                              }
                            }
                            return AnimatedKcalGraph(
                              isAll: item.isShowAll,
                              key: item.isShowAll ? null : UniqueKey(),
                              value: value,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => InformationScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20),
                  ),
                  child: Text(
                    "자세히 알아보기",
                    style: defaultFont.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w100,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: getProportionateScreenHeight(300),
                child: Consumer<MealsProvider>(
                  builder: (ctx, item, _) {
                    final meals = item.meals;
                    if (item.status == MealsEnum.food_searching) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (item.status == MealsEnum.error_food_searching) {
                      return Center(child: Text("급식을 찾을 수 가 없습니다."));
                    }
                    return Swiper(
                      viewportFraction: 0.6,
                      scale: 0.8,
                      itemCount: 3,
                      index: swiper_provider.index,
                      onIndexChanged: (index) {
                        swiper_provider.index = index;
                      },
                      itemBuilder: (ctx, idx) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(20),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x10000000),
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    titles[idx],
                                    style: defaultFont.copyWith(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                height: getProportionateScreenHeight(60),
                              ),
                              Container(
                                child: Builder(
                                  builder: (_) {
                                    final meal = meals.getFromIdx(idx);
                                    if (meals.isEmpty(idx))
                                      return Text("급식이 없습니다.");
                                    return SizedBox(
                                      height: getProportionateScreenHeight(200),
                                      child: ListView.builder(
                                        itemBuilder: (_, index) => Center(
                                            child: Text(
                                          meal.lists[index],
                                          style: defaultFont.copyWith(
                                              fontSize: 16),
                                        )),
                                        itemCount: meal.lists.length,
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
