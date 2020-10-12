import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/provider/user_provider.dart';
import 'package:school_food/services/sizeconfig.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      //print(scrollController.offset);
    });
    SizeConfig().init(context);
    final userOption = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<UserProvider>(
            builder: (ctx, item, _) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            item.gender = Gender.MAN;
                            item.saveData();
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    getProportionateScreenWidth(10)),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.mars,
                                        size: SizeConfig.screenWidth / 4,
                                        color: item.gender == Gender.MAN
                                            ? Colors.blue
                                            : textColor.withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      "남",
                                      style: defaultFont.copyWith(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            item.gender = Gender.WOMAN;
                            item.saveData();
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    getProportionateScreenWidth(10)),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.venus,
                                        size: SizeConfig.screenWidth / 4,
                                        color: item.gender == Gender.WOMAN
                                            ? Colors.pink
                                            : textColor.withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      "여",
                                      style: defaultFont.copyWith(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10),
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10)),
                        child: Text("나이",
                            style: defaultFont.copyWith(fontSize: 24)),
                      ),
                      Container(
                        width: double.infinity,
                        height: getProportionateScreenHeight(60),
                        child: ScrollSnapList(
                          itemBuilder: (ctx, idx) => Container(
                            width: 75,
                            child: Center(
                              child: Text(
                                "$idx",
                                style: idx == item.age
                                    ? defaultFont.copyWith(fontSize: 24)
                                    : defaultFont,
                              ),
                            ),
                          ),
                          itemCount: 100,
                          initialIndex: item.age.toDouble(),
                          scrollDirection: Axis.horizontal,
                          dynamicItemSize: true,
                          onItemFocus: (idx) async {
                            item.age = idx;
                            await item.saveData();
                          },
                          itemSize: 75,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10),
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10)),
                        child: Text("키",
                            style: defaultFont.copyWith(fontSize: 24)),
                      ),
                      Container(
                        width: double.infinity,
                        height: getProportionateScreenHeight(60),
                        child: ScrollSnapList(
                          itemBuilder: (ctx, idx) => Container(
                            width: 75,
                            child: Center(
                              child: Text(
                                "$idx",
                                style: idx == item.height
                                    ? defaultFont.copyWith(fontSize: 24)
                                    : defaultFont,
                              ),
                            ),
                          ),
                          itemCount: 200,
                          initialIndex: item.height.toDouble(),
                          scrollDirection: Axis.horizontal,
                          dynamicItemSize: true,
                          onItemFocus: (idx) async {
                            item.height = idx;
                            await item.saveData();
                          },
                          itemSize: 75,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20),
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "슬라이드로 날짜 변경",
                        style: defaultFont.copyWith(fontSize: 16),
                      ),
                      CustomTabs(
                        initialIndex: userOption.useSwiperNextDay ? 0 : 1,
                        onPress: (newIdx) {
                          userOption.useSwiperNextDay = newIdx == 0;
                          userOption.saveData();
                        },
                      )
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showLicensePage(
                        context: context,
                        applicationIcon: Image.asset("assets/Appicon.png"));
                  },
                  child: Text("오픈소스 라이센스", style: defaultFont),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  final ValueChanged<int> onPress;
  final int initialIndex;
  const CustomTabs({
    Key key,
    @required this.initialIndex,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.5),
      ),
      child: DefaultTabController(
        initialIndex: initialIndex,
        length: 2,
        child: TabBar(
          labelPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
          ),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.5),
          ),
          labelStyle: defaultFont,
          labelColor: textColor,
          onTap: onPress,
          tabs: [
            Tab(
              text: "활성화",
            ),
            Tab(
              text: "비활성화",
            ),
          ],
        ),
      ),
    );
  }
}
