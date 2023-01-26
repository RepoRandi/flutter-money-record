import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/controller/history/c_add_history.dart';

import '../../../config/app_color.dart';

class AddHistoryPage extends StatelessWidget {
  AddHistoryPage({Key? key}) : super(key: key);

  final cUser = Get.put(CUser());
  final cAddHistory = Get.put(CAddHistory());
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();

  addHistory() async {
    bool success = await SourceHistory.add(
      '${cUser.data.idUser}',
      cAddHistory.date,
      cAddHistory.type,
      jsonEncode(cAddHistory.items),
      '${cAddHistory.total}',
    );
    if (success) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cAddHistory = Get.put(CAddHistory());
    final controllerName = TextEditingController();
    final controllerPrice = TextEditingController();

    return Scaffold(
      appBar: DView.appBarLeft('Tambah Baru'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tanggal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Obx(() {
                return Text(
                  cAddHistory.date,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                );
              }),
              DView.spaceWidth(),
              ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023,01,01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (date != null) {
                      cAddHistory
                          .setDate(DateFormat('yyyy-MM-dd').format(date));
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: const Text('Pilih')),
            ],
          ),
          DView.spaceHeight(),
          const Text(
            'Tipe',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(8),
          Obx(() {
            return DropdownButtonFormField(
              value: cAddHistory.type,
              items: ['Pemasukan', 'Pengeluaran'].map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                cAddHistory.setType(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            );
          }),
          DView.spaceHeight(),
          DInput(
            controller: controllerName,
            title: 'Sumber / Objek Pengeluaran',
            hint: 'Input sumber atau pengeluaran anda',
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerPrice,
            title: 'Harga',
            hint: 'Input harga',
            inputType: TextInputType.number,
          ),
          DView.spaceHeight(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: ElevatedButton(
              onPressed: () {
                if (controllerName.text != '' && controllerPrice.text != '') {
                  cAddHistory.addItem({
                    'name': controllerName.text,
                    'price': controllerPrice.text,
                  });
                  controllerName.clear();
                  controllerPrice.clear();
                } else {
                  DInfo.dialogError(context, 'Item kosong');
                  DInfo.closeDialog(context);
                }
              },
              child: const Text('Add Item'),
            ),
          ),
          DView.spaceHeight(),
          Center(
            child: Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(
                color: AppColor.bg,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          DView.spaceHeight(),
          const Text(
            'Items',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DView.spaceHeight(8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: GetBuilder<CAddHistory>(
              builder: (chip) {
                return Wrap(
                  spacing: 8,
                  children: List.generate(chip.items.length, (index) {
                    return Chip(
                      label: Text(chip.items[index]['name']),
                      labelStyle: const TextStyle(color: AppColor.white),
                      deleteIcon: const Icon(Icons.clear),
                      deleteIconColor: AppColor.white,
                      onDeleted: () => chip.deleteItem(index),
                      backgroundColor: AppColor.primary,
                    );
                  }),
                );
              },
            ),
          ),
          DView.spaceHeight(),
          Row(
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DView.spaceWidth(10),
              Obx(() {
                return Text(
                  AppFormat.currency(cAddHistory.total.toString()),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                );
              }),
            ],
          ),
          DView.spaceHeight(50),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => addHistory(),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
