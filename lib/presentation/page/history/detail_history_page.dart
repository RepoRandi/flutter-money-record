import 'dart:convert';

import 'package:d_view/d_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/presentation/controller/history/c_detail_history.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage({Key? key, required this.idUser, required this.date, required this.type})
      : super(key: key);
  final String idUser;
  final String date;
  final String type;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(
          () {
            if (cDetailHistory.data.date == null) return DView.nothing();
            return Row(
              children: [
                Expanded(
                  child: Text(
                    AppFormat.date(widget.date),
                  ),
                ),
                cDetailHistory.data.type == 'Pemasukan'
                    ? const Icon(
                        Icons.south_west,
                        color: AppColor.green,
                      )
                    : const Icon(
                        Icons.north_east,
                        color: AppColor.red,
                      ),
                DView.spaceWidth(),
              ],
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: GetBuilder<CDetailHistory>(
          assignId: true,
          builder: (_) {
            if (_.data.date == null) {
             String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
             if (widget.date == today && widget.type == 'Pengeluaran') {
               return DView.empty('Belum ada pengeluaran hari ini');
             }
              return DView.nothing();
            }
            List details = jsonDecode(_.data.details!);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.bg,
                  ),
                ),
                DView.spaceHeight(5),
                Text(
                  AppFormat.currency('${_.data.total}'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                DView.spaceHeight(20),
                Center(
                  child: Container(
                    height: 5,
                    width: 120,
                    decoration: BoxDecoration(
                        color: AppColor.bg,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                DView.spaceHeight(),
                Expanded(
                  child: ListView.separated(
                    itemCount: details.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      Map item = details[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            DView.spaceWidth(5),
                            Expanded(
                              child: Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Text(
                              AppFormat.currency(
                                item['price'],
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
