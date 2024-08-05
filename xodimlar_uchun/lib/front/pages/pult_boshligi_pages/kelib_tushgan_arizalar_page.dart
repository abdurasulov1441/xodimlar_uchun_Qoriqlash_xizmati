import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:xodimlar_uchun/front/components/custom_appbar.dart';
import 'package:xodimlar_uchun/front/pages/pult_boshligi_pages/ariza_pult_boshligi.dart';
import 'package:xodimlar_uchun/front/pages/pult_boshligi_pages/pult_boshligi_home.dart';
import 'package:xodimlar_uchun/front/style/app_colors.dart';
import 'package:xodimlar_uchun/front/style/app_style.dart';

class KelibTushganArizalarPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  KelibTushganArizalarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
        drawer: Drawer(
          child: Container(
            color: AppColors.customAppBarColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.customAppBarColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/set.png', // Путь к вашему изображению логотипа
                        height: 50,
                      ),
                      SizedBox(height: 5),
                      Text('Qo\'riqlash xizmati',
                          style: AppStyle.fontStyle.copyWith(
                              fontSize: 18, color: AppColors.lightHeaderColor)),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Bosh sahifa',
                      style: AppStyle.fontStyle
                          .copyWith(color: AppColors.lightHeaderColor)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PultBoshligiHome()),
                    );
                  },
                ),
                Container(
                  color: AppColors.selectedIconColor,
                  child: ListTile(
                    leading: Icon(Icons.assignment, color: Colors.white),
                    title: Text('Kelib tushgan ariza',
                        style: AppStyle.fontStyle
                            .copyWith(color: AppColors.lightHeaderColor)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.description, color: Colors.white),
                  title: Text('AKT',
                      style: AppStyle.fontStyle
                          .copyWith(color: AppColors.lightHeaderColor)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book, color: Colors.white),
                  title: Text('Dalolatnomalar',
                      style: AppStyle.fontStyle
                          .copyWith(color: AppColors.lightHeaderColor)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel, color: Colors.white),
                  title: Text('Bekor bo\'lgan arizalar',
                      style: AppStyle.fontStyle
                          .copyWith(color: AppColors.lightHeaderColor)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.uxuiColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text('Kelib tushgan arizalar',
                      style: AppStyle.fontStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                  child:
                      SizedBox(width: double.infinity, child: CustomListView()))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print('object');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArizaPultBoshligiPage(index: index)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Ariza',
                            style: AppStyle.fontStyle.copyWith(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('12 651',
                            style: AppStyle.fontStyle.copyWith(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Kelib tushgan sana',
                            style: AppStyle.fontStyle
                                .copyWith(fontSize: 8, color: Colors.grey)),
                        Text('25.12.2024yil',
                            style: AppStyle.fontStyle
                                .copyWith(fontSize: 8, color: Colors.grey)),
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.grey, width: 1),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle,
                                color: AppColors.lightIconGuardColor, size: 16),
                            SizedBox(width: 4),
                            Text('Rahimov Voris',
                                style: AppStyle.fontStyle.copyWith(
                                    color: AppColors.lightIconGuardColor,
                                    fontSize: 12)),
                            Spacer(),
                            Icon(Icons.phone,
                                color: AppColors.lightIconGuardColor, size: 14),
                            SizedBox(width: 3),
                            Text('+998 (99) 786 25 51',
                                style: AppStyle.fontStyle.copyWith(
                                    color: AppColors.lightIconGuardColor,
                                    fontSize: 10)),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        Divider(color: Colors.grey),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('1-qadam',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                            Text('2-qadam',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                            Text('3-qadam',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                            Text('4-qadam',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StepsIndicator(
                              selectedStep: 0,
                              nbSteps: 4,
                              selectedStepColorOut: Colors.blue,
                              selectedStepColorIn: Colors.white,
                              doneStepColor:
                                  const Color.fromRGBO(33, 150, 243, 1),
                              doneLineColor: Colors.blue,
                              undoneLineColor: Colors.blue,
                              isHorizontal: true,
                              lineLength: 55,
                              doneStepSize: 10,
                              unselectedStepSize: 10,
                              selectedStepSize: 14,
                              selectedStepBorderSize: 1,
                              doneStepWidget: SvgPicture.asset(
                                'assets/images/progres_on.svg',
                                width: 20,
                                height: 20,
                              ), // Custom Widget
                              unselectedStepWidget: SvgPicture.asset(
                                'assets/images/progres_off.svg',
                                width: 20,
                                height: 20,
                              ), // Custom Widget
                              selectedStepWidget: SvgPicture.asset(
                                'assets/images/progres_on.svg',
                                width: 20,
                                height: 20,
                              ), // Custom Widget
                              lineLengthCustomStep: [
                                StepsIndicatorCustomLine(nbStep: 5, length: 200)
                              ],
                              enableLineAnimation: true,
                              enableStepAnimation: true,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Bayonnoma',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                            Text('Shartnoma',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                            Text('Dalolatnoma',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                            Text('Shartnoma ilova',
                                style:
                                    AppStyle.fontStyle.copyWith(fontSize: 10)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckboxExample extends StatefulWidget {
  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: _toggleCheckbox,
        ),
      ],
    );
  }
}
