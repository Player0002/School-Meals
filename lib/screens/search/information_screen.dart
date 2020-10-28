import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/provider/meals_provider.dart';
import 'package:school_food/provider/swiper_provider.dart';
import 'package:school_food/provider/user_provider.dart';
import 'package:school_food/screens/search/components/bar_graph.dart';
import 'package:school_food/services/sizeconfig.dart';

class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final titles = ["아침", "점심", "저녁"];
    final index = Provider.of<SwiperProvider>(context, listen: false);
    final userOption = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(40),
                ),
                child: Text(
                  "${titles[index.index]}",
                  maxLines: 1,
                  style: defaultFont.copyWith(fontSize: 24),
                ),
              ),
              Expanded(
                child: Consumer<MealsProvider>(
                  builder: (ctx, item, _) {
                    if (item == null) {
                      return Text("자세한 정보가 없습니다.");
                    }
                    final meal = item.meals.getFromIdx(index.index);
                    if (item.meals.isEmpty(index.index)) {
                      return Center(child: Text("급식이 없습니다."));
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(320),
                          width: double.infinity,
                          child: BarGraphImage(
                            key: UniqueKey(),
                            background: Theme.of(context).backgroundColor,
                            height: getProportionateScreenHeight(260),
                            meal: meal,
                            humanAge: userOption.age,
                            humanGender: userOption.gender,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(20)),
                          child: Text(
                            "세부정보",
                            style: defaultFont.copyWith(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, idx) {
                              final list = meal.NTR;
                              final current = list[idx].split(" : ");
                              return ListTile(
                                title: Text(current[0]),
                                subtitle: Text(current[1]),
                              );
                            },
                            itemCount: meal.NTR.length,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
