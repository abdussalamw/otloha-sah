import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import '../widget/user_config_selection.dart';

class RegisterStepsPage extends StatelessWidget {
  const RegisterStepsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CupertinoStepper(
          steps: const [
            Step(
              title: Text('Compelete your profile'),
              content: UserConfigSelection(),
            ),
            Step(
              title: Text('Quran Settings'),
              content: UserConfigSelection(),
            ),
            Step(
              title: Text('Choose Your Role'),
              content: UserConfigSelection(),
            ),
            Step(
              title: Text('Teacher Form'),
              content: UserConfigSelection(),
            ),
          ],
        ),
      ),
    );
  }
}
