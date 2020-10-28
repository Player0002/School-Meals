import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/provider/meals_provider.dart';
import 'package:school_food/provider/school_provider.dart';
import 'package:school_food/provider/search_provider.dart';
import 'package:school_food/screens/search/school_screen.dart';
import 'package:school_food/services/sizeconfig.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final provider = Provider.of<SearchProvider>(context, listen: false);
    final topProvider = Provider.of<SchoolProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MealsProvider>(context, listen: false)
          .loadingFood(topProvider.selectedSchool, 0, 0);
    });
    return Scaffold(
      //backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          "학교 찾아보기",
          style: defaultFont.copyWith(fontSize: 24),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Column(
        children: [
          SearchBox(
            onPress: () {
              provider.search();
            },
            textController: provider.textController,
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (ctx, item, _) {
                if (item.status == SearchStatus.searching) {
                  return Center(child: CircularProgressIndicator());
                }
                if (item.status == SearchStatus.end_searching) {
                  return ListView.builder(
                    itemCount: item.searchModel.models.length,
                    itemBuilder: (ctx, idx) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10),
                        horizontal: getProportionateScreenWidth(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          topProvider
                              .selectSchool(item.searchModel.models[idx]);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => SchoolScreen(),
                            ),
                            (r) => false,
                          );
                          // 난 개인적으로 여기선 그냥 idx를 넘겨주고 메인 화면에서 처리하면 좋겠음.
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenHeight(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  child: Text(
                                    "${item.searchModel.models[idx].school_name}",
                                    style: defaultFont.copyWith(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .color),
                                    maxLines: 1,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Text(
                                  "${item.searchModel.models[idx].address}",
                                  style: defaultFont.copyWith(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .color),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Center(child: Text("검색된 학교가 없습니다."));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
    @required this.textController,
    @required this.onPress,
  }) : super(key: key);

  final TextEditingController textController;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: getProportionateScreenWidth(335),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x10000000),
                    offset: Offset(0, 0),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
                color: Theme.of(context).backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: textController,
                        style: defaultFont.copyWith(
                          color: Theme.of(context).textTheme.headline3.color,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "여기에 학교이름을 입력하세요.",
                          hintStyle: defaultFont.copyWith(
                            color: Theme.of(context).textTheme.headline3.color,
                          ),
                        ),
                        onSubmitted: (text) => {onPress()},
                      ),
                    ),
                    Material(
                      elevation: 0,
                      color: Theme.of(context).backgroundColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(360),
                        onTap: onPress,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
