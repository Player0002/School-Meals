import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/provider/theme_provider.dart';
import 'package:school_food/provider/user_provider.dart';
import 'package:school_food/services/sizeconfig.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class SettingScreen extends StatelessWidget {
  final GlobalKey _dropKey = LabeledGlobalKey(kUserTheme);
  final Key key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      //print(scrollController.offset);
    });
    final list = ["시스템", "주간", "야간"];
    SizeConfig().init(context);
    final userOption = Provider.of<UserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userOption.useScroll = false;
    });
    ThemeProvider provider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (ctx, userOption, _) => IgnorePointer(
            ignoring: userOption.useScroll,
            child: SingleChildScrollView(
              child: Column(
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
                              userOption.gender = Gender.MAN;
                              userOption.saveData();
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
                                          color: userOption.gender == Gender.MAN
                                              ? Colors.blue
                                              : textColor.withOpacity(0.5),
                                        ),
                                      ),
                                      Text(
                                        "남",
                                        style:
                                            defaultFont.copyWith(fontSize: 24),
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
                              userOption.gender = Gender.WOMAN;
                              userOption.saveData();
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
                                          color:
                                              userOption.gender == Gender.WOMAN
                                                  ? Colors.pink
                                                  : textColor.withOpacity(0.5),
                                        ),
                                      ),
                                      Text(
                                        "여",
                                        style:
                                            defaultFont.copyWith(fontSize: 24),
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
                                  style: idx == userOption.age
                                      ? defaultFont.copyWith(fontSize: 24)
                                      : defaultFont,
                                ),
                              ),
                            ),
                            itemCount: 100,
                            initialIndex: userOption.age.toDouble(),
                            scrollDirection: Axis.horizontal,
                            dynamicItemSize: true,
                            onItemFocus: (idx) async {
                              userOption.age = idx;
                              await userOption.saveData();
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(20),
                      horizontal: getProportionateScreenWidth(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "날짜 선택 방법",
                          style: defaultFont.copyWith(fontSize: 16),
                        ),
                        CustomTabs(
                          first: "달력",
                          seconds: "스크롤",
                          initialIndex: userOption.useMaterialDay ? 0 : 1,
                          onPress: (newIdx) {
                            userOption.useMaterialDay = newIdx == 0;
                            userOption.saveData();
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(20),
                      horizontal: getProportionateScreenWidth(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "앱 테마",
                          style: defaultFont.copyWith(fontSize: 16),
                        ),
                        ThemeDropBox(
                          key: key,
                          dropKey: _dropKey,
                          userOption: userOption.userThemeStr,
                          statusChange: (status) {
                            print(status);
                            userOption.useScroll = status;
                          },
                          list: list,
                          onChange: (i) {
                            if (i == 0)
                              userOption.userTheme = CustomTheme.SYSTEM;
                            if (i == 1)
                              userOption.userTheme = CustomTheme.LIGHT;
                            if (i == 2) userOption.userTheme = CustomTheme.DARK;
                            provider.setThemeMode(userOption.userThemeInt == 1
                                ? ThemeMode.system
                                : userOption.userThemeInt == 2
                                    ? ThemeMode.light
                                    : ThemeMode.dark);
                            userOption.saveData();
                          },
                        ),
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
      ),
    );
  }
}

class ThemeDropBox extends StatefulWidget {
  const ThemeDropBox(
      {Key key,
      @required Key dropKey,
      @required this.userOption,
      @required this.list,
      @required this.onChange,
      @required this.statusChange})
      : _dropKey = dropKey,
        super(key: key);

  final Key _dropKey;
  final String userOption;
  final List<String> list;
  final ValueChanged<int> onChange;
  final ValueChanged<bool> statusChange;
  @override
  State<StatefulWidget> createState() {
    return ThemeDropBoxState();
  }
}

class ThemeDropBoxState extends State<ThemeDropBox> {
  GlobalKey _dropKey;
  String userOption;
  bool _isMenuOpen = false;
  bool get isMenuOpen => _isMenuOpen;
  set isMenuOpen(val) {
    _isMenuOpen = val;
    widget.statusChange(_isMenuOpen);
  }

  Size buttonSize;
  OverlayEntry _overlayEntry;
  Offset btnPosition;

  @override
  void initState() {
    _dropKey = widget._dropKey;
    userOption = widget.userOption;
    super.initState();
  }

  findButton() {
    RenderBox box = _dropKey.currentContext.findRenderObject();
    buttonSize = box.size;
    btnPosition = box.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }

    super.dispose();
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(builder: (ctx) {
      return Positioned(
        top: btnPosition.dy -
            (buttonSize.height * (widget.list.length - 1)) -
            getProportionateScreenHeight(10),
        left: btnPosition.dx,
        width: buttonSize.width,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  height: widget.list.length * buttonSize.height,
                  decoration: BoxDecoration(
                      color: Color(0xFFCBCBCB),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.2,
                          blurRadius: 5,
                        )
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.list.length,
                      (index) => GestureDetector(
                        onTap: () {
                          widget.onChange(index);
                          closeMenu();
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: buttonSize.width,
                          height: buttonSize.height,
                          child: Center(
                            child: Text(
                              widget.list[index],
                              style: defaultFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (isMenuOpen)
          closeMenu();
        else
          openMenu();
      },
      child: Container(
        key: _dropKey,
        width: SizeConfig.screenWidth * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15),
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Text(
                "${provider.userThemeStr}",
                style: defaultFont.copyWith(),
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  final ValueChanged<int> onPress;
  final int initialIndex;
  final String first;
  final String seconds;
  const CustomTabs({
    Key key,
    @required this.initialIndex,
    @required this.onPress,
    this.first,
    this.seconds,
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
              text: first ?? "활성화",
            ),
            Tab(
              text: seconds ?? "비활성화",
            ),
          ],
        ),
      ),
    );
  }
}
