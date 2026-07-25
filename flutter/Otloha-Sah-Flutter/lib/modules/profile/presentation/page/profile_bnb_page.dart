import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth_module/presentation/pages/login_page.dart';
import '../../business_logic/profile_pic_cubit/profile_page_cubit.dart';
import '../widget/profile_page_widget.dart';

class ProfileBNBPage extends StatefulWidget {
  const ProfileBNBPage({super.key, this.user});
  final User? user;

  @override
  State<ProfileBNBPage> createState() => _ProfileBNBPageState();
}

class _ProfileBNBPageState extends State<ProfileBNBPage> {
  var cubit;
  @override
  void initState() {
    cubit = ProfilePageCubit.get(context);
    cubit.userProfile(user: widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePageCubit, ProfilePageState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is NoAuthState) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          });
        }
        if (state is GetProfilePageLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetProfilePageError) {
          return ErrorIndicator(error: state.error);
        }

        if (cubit.currentUserProfile == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child:  ProfilePage(user: widget.user),
          ),
          //ComingSoonPage(),
        );
      },
    );
  }
}
