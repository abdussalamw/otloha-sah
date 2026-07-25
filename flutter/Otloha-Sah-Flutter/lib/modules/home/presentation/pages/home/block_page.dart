import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/onboard_page.dart';

import '../../../../../data_source/data_source.dart';
import '../../../../../data_source/remote/firebase_service.dart';
import '../../../../../data_source/user_services_data.dart';
import '../../../../splash/business_logic/cubit/splash_cubit.dart';

class BlockedPage extends StatelessWidget {
  static const route = 'block_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.block,
              size: 64.0,
              color: Colors.red,
            ),
            const SizedBox(height: 16.0),
            Text(
              translate(
                  'We regret to inform you that your account has beenblocked.'),
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              translate(
                  'Please contact the administrator for further assistance.'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff00D2FF),
                    Color(0xff3A7BD5),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  AppDataSource().logOut();
                  await FirebaseService.instance.deleteToken();
                  SplashCubit.signOut();
                  UserDataServices.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    OnBoardPage.routeName,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(translate('Return to Onboard')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
