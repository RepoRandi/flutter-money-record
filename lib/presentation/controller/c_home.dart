import 'package:get/get.dart';
import 'package:money_record/data/source/source_history.dart';

class CHome extends GetxController {
  final _today = 0.0.obs;
  double get today => _today.value;

  final _todayPercent = ''.obs;
  String get todayPercent => _todayPercent.value;

  final _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  List<double> get week => _week.value;

  List<String> get days => ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  List<String> weekText() {
    DateTime today = DateTime.now();
    return [
      days[today.subtract(const Duration(days: 6)).weekday - 1],
      days[today.subtract(const Duration(days: 5)).weekday - 1],
      days[today.subtract(const Duration(days: 4)).weekday - 1],
      days[today.subtract(const Duration(days: 3)).weekday - 1],
      days[today.subtract(const Duration(days: 2)).weekday - 1],
      days[today.subtract(const Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }


  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _percentIncome = ''.obs;
  String get percentIncome => _percentIncome.value;

  final _monthPercent = ''.obs;
  String get monthPercent => _monthPercent.value;

  final _monthDifferent = 0.0.obs;
  double get monthDifferent => _monthDifferent.value;

  getAnalysis(String idUser) async {
    Map data = await SourceHistory.analysis(idUser);

    _today.value = data['today'].toDouble();
    double yesterday = data['yesterday'].toDouble();
    double different = (today - yesterday).abs();
    bool isSame = today.isEqual(yesterday);
    bool isPlus = today.isGreaterThan(yesterday);
    double byYesterday = yesterday == 0 ? 1 : yesterday;
    double percent = (different / byYesterday) * 100;
    _todayPercent.value = isSame
        ? '100% sama dengan kemaren'
        : isPlus
            ? '+${percent.toStringAsFixed(1)}% dibanding kemaren'
            : '-${percent.toStringAsFixed(1)}% dibanding kemaren';

    _week.value = List.castFrom(data['week'].map((e) => e.toDouble()).toList());

    _monthIncome.value = data['month']['income'].toDouble();
    _monthOutcome.value = data['month']['outcome'].toDouble();
    _monthDifferent.value = (monthIncome -  monthOutcome).abs();
    bool isSameMonth = monthIncome.isEqual(monthOutcome);
    bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);
    double byOutcome = monthOutcome == 0 ? 1 : monthOutcome;
    double percentMonth = (monthDifferent / byOutcome) * 100;
    _percentIncome.value = ((monthDifferent / byOutcome) * 100).toStringAsFixed(1);
    _monthPercent.value = isSameMonth
        ? 'Pemasukan\n100% sama\ndengan Pengeluaran'
        : isPlusMonth
            ? 'Pemasukan\nlebih besar ${percentMonth.toStringAsFixed(1)}%\ndari Pengeluaran'
            : 'Pemasukan\nlebih kecil ${percentMonth.toStringAsFixed(1)}%\ndari Pengeluaran';
  }
}