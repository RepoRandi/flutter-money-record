import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () async {
                Session.clearUser();
                bool? yes = await DInfo.dialogConfirmation(
                    context, 'Logout', 'You sure logout from this account');
                if (yes ?? false) {
                  DInfo.toastSuccess('Logout success');
                  Get.off(() => const LoginPage());
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
