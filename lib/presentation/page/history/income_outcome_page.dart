import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/controller/history/c_income_outcome.dart';

class IncomeOutcomePage extends StatefulWidget {
  const IncomeOutcomePage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final cUser = Get.put(CUser());
  final cInOut = Get.put(CIncomeOutcome());
  final controllerSearch = TextEditingController();

  refresh() {
    cInOut.getList(cUser.data.idUser, widget.type);
  }

  search() {
    cInOut.search(cUser.data.idUser, widget.type, controllerSearch.text);
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Text(widget.type),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  controller: controllerSearch,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (date != null) {
                      controllerSearch.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColor.chart,
                    suffixIcon: IconButton(
                      onPressed: () => search(),
                      icon: const Icon(
                        Icons.search,
                        color: AppColor.white,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    hintText: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    hintStyle: const TextStyle(
                      color: AppColor.white,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CIncomeOutcome>(builder: (_) {
        if (_.loading) return DView.loadingBar();
        if (_.list.isEmpty) return DView.empty('${widget.type} Kosong');
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: _.list.length,
            itemBuilder: (context, index) {
              History history = _.list[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(
                  16,
                  index == 0 ? 16 : 8,
                  16,
                  index == _.list.length - 1 ? 16 : 8,
                ),
                child: Row(
                  children: [
                    DView.spaceWidth(),
                    Text(
                      AppFormat.date(history.date!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppFormat.currency(history.total!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [],
                      onSelected: (value) {},
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
