import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:school_food/provider/user_provider.dart';
import 'package:school_food/services/sizeconfig.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      //print(scrollController.offset);
    });
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
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
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          child: Padding(
                            padding:
                                EdgeInsets.all(getProportionateScreenWidth(10)),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.black,
                                ),
                                Text("CARD"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          child: Padding(
                            padding:
                                EdgeInsets.all(getProportionateScreenWidth(10)),
                            child: Column(
                              children: [
                                Container(),
                                Text("CARD"),
                              ],
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
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: [
                    Text("나이"),
                    NotificationListener(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          print((notification.metrics.pixels / 50.0 + 0.5)
                              .toInt());
                        }
                        return true;
                      },
                      child: Container(
                        width: double.infinity,
                        height: getProportionateScreenHeight(60),
                        child: NumberPicker.horizontal(
                          initialValue: item.age,
                          minValue: 1,
                          maxValue: 100,
                          onChanged: (changed) {
                            item.age = changed;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
