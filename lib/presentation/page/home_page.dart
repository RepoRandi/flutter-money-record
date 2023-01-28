import 'package:d_chart/d_chart.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/controller/c_home.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';
import 'package:money_record/presentation/page/history/add_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer(cUser: cUser, cHome: cHome,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Row(
              children: [
                Image.asset(AppAsset.profile),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(
                        () => Text(
                          cUser.data.name ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  return Material(
                    color: AppColor.chart,
                    borderRadius: BorderRadius.circular(8.0),
                    child: InkWell(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.menu,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                cHome.getAnalysis(cUser.data.idUser!);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                children: [
                  const Text(
                    'Pengeluaran Hari Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DView.spaceHeight(),
                  cardToday(context),
                  DView.spaceHeight(30),
                  Center(
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                          color: AppColor.bg,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  DView.spaceHeight(30),
                  const Text(
                    'Pengeluaran Minggu Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DView.spaceHeight(),
                  weekly(),
                  DView.spaceHeight(30),
                  const Text(
                    'Perbandingan Bulan Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DView.spaceHeight(),
                  monthly(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Material cardToday(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(() {
              return Text(
                AppFormat.currency(cHome.today.toString()),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondary,
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 4),
            child: Obx(() {
              return Text(
                cHome.todayPercent,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.chart,
                ),
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 0, 20),
            padding: const EdgeInsets.only(top: 6, right: 6, bottom: 6),
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Selengkapnya',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.primary,
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  color: AppColor.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AspectRatio weekly() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() {
        return DChartBar(
          data: [
            {
              'id': 'Bar',
              'data': List.generate(7, (index) {
                return {
                  'domain': cHome.weekText()[index],
                  'measure': cHome.week[index],
                };
              })
            },
          ],
          domainLabelPaddingToAxisLine: 8,
          axisLineTick: 2,
          axisLineColor: AppColor.chart,
          measureLabelPaddingToAxisLine: 16,
          barColor: (barData, index, id) => AppColor.primary,
          showBarValue: true,
        );
      }),
    );
  }

  Row monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Stack(children: [
            Obx(() {
              return DChartPie(
                data: [
                  {'domain': 'income', 'measure': cHome.monthIncome},
                  {'domain': 'outcome', 'measure': cHome.monthOutcome},
                  if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                    {'domain': 'nol', 'measure': 1},
                ],
                fillColor: (pieData, index) {
                  switch (pieData['domain']) {
                    case 'income':
                      return AppColor.primary;
                    case 'outcome':
                      return AppColor.chart;
                    default:
                      return AppColor.bg.withOpacity(0.5);
                  }
                },
                donutWidth: 20,
                labelColor: Colors.transparent,
                showLabelLine: false,
              );
            }),
            Center(
              child: Obx(() {
                return Text(
                  '${cHome.percentIncome}%',
                  style: const TextStyle(
                    fontSize: 30,
                    color: AppColor.primary,
                  ),
                );
              }),
            ),
          ]),
        ),
        DView.spaceWidth(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.primary,
                ),
                DView.spaceWidth(8),
                Text(
                  'Pemasukan',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            DView.spaceHeight(8),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.chart,
                ),
                DView.spaceWidth(8),
                Text(
                  'Pengeluaran',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            DView.spaceHeight(20),
            Obx(() {
              return Text(
                cHome.monthPercent,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              );
            }),
            DView.spaceHeight(10),
            Text(
              'Atau setara:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            Obx(() {
              return Text(
                AppFormat.currency(cHome.monthDifferent.toString()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              );
            })
          ],
        ),
      ],
    );
  }
}

class drawer extends StatelessWidget {
  const drawer({
    Key? key,
    required this.cUser,
    required this.cHome,
  }) : super(key: key);

  final CUser cUser;
  final CHome cHome;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppAsset.profile),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            cUser.data.name ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            cUser.data.email ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                DView.spaceHeight(),
                Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () async {
                      Session.clearUser();
                      bool? yes = await DInfo.dialogConfirmation(context,
                          'Logout', 'You sure logout from this account');
                      if (yes ?? false) {
                        Fluttertoast.showToast(
                            msg: "Logout berhasil",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColor.green,
                            textColor: AppColor.white,
                            fontSize: 16.0);
                        Get.off(() => const LoginPage());
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const Divider(),
          ListTile(
            onTap: () {
              Get.to(() => AddHistoryPage())?.then((value) {
                if (value ?? false) {
                  cHome.getAnalysis(cUser.data.idUser!);
                }
              });
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: const Text('Tambah Baru'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: const Text('Pemasukan'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: const Text('Pengeluaran'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.history),
            horizontalTitleGap: 0,
            title: const Text('Riwayat'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
