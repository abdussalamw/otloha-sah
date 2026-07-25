import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../profile/presentation/widget/user_name_view.dart';

class ItemTeacher extends StatelessWidget {
  const ItemTeacher({
    Key? key,
    required this.userName,
    required this.rate,
    required this.userId,
    this.userbio,
    required this.action,
    required this.typeView,
    this.isCertified = false,
    this.setFav,
    this.isFav,
    this.isStudent = false,
    this.results,
    required this.userImg,
  }) : super(key: key);
  final User? results;
  final bool typeView;
  final bool isCertified;
  final bool? isFav;
  final bool isStudent;

  final String userName;
  final String rate;
  final String userId;
  final String? userbio;
  final String userImg;

  final Function()? action;
  final Function()? setFav;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColor.backItem,
      child: ListTile(
        contentPadding: const EdgeInsets.all(4),
        onTap: action,
        leading: CachedImage(
          url: userImg,
          raduis: 30,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _viewName(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [..._iconsView(16)],
            )
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(
              text: userId,
              padding: EdgeInsets.zero,
              sizeText: 10,
              colorText: AppColor.txtColor4,
              textAlign: TextAlign.start,
            ),
            if (userbio != null)
              TextView(
                text: userbio ?? '',
                padding: EdgeInsets.zero,
                sizeText: 10,
                colorText: AppColor.txtColor4,
                textAlign: TextAlign.start,
                // overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  _viewName(context) {
    return SizedBox(
      // width: 150,
      child: UserNameView(
        typeUser: _getUserType(),
        isCertified: !isStudent && isCertified,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.txtColor4,
                overflow: TextOverflow.ellipsis,
              ),
              // padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _iconsView(double size) {
    return [
      TextView(
        text: rate,
        weightText: FontWeight.bold,
        padding: EdgeInsets.zero,
        sizeText: 16,
        colorText: AppColor.txtColor4,
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          Icons.star_border,
          color: AppColor.iconColor3,
          size: size,
        ),
      ),
      InkWell(
        onTap: () {
          //  cubit.markAsFavTeacher(id:cubit.teachers!);
          setFav!();
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            (isFav ?? false) ? (Icons.favorite) : (Icons.favorite_border),
            color: (isFav ?? false) ? Colors.red : AppColor.iconColor,
            size: size,
          ),
        ),
      ),
    ];
  }

  _getUserType() {
    if (!isStudent) {
      return isCertified ? TypeUser.paidTeacher : TypeUser.approvedTeacher;
    } else {
      return TypeUser.student;
    }
  }
}

class ItemTeacherGrid extends StatelessWidget {
  const ItemTeacherGrid({
    Key? key,
    required this.userName,
    required this.rate,
    required this.userId,
    required this.userbio,
    required this.action,
    required this.typeView,
    required this.fullName,
    this.isCertified = false,
    this.setFav,
    this.isFav,
    this.isStudent = false,
    this.results,
    required this.userImg,
  }) : super(key: key);
  final User? results;
  final bool typeView;
  final bool isCertified;
  final bool? isFav;
  final bool isStudent;
  final String fullName;

  final String userName;
  final String rate;
  final String userId;
  final String? userbio;
  final String userImg;

  final Function()? action;
  final Function()? setFav;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColor.backItem,
      child: _viewGrid(),
    );
  }

  _viewGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _userImage(),
          _viewName(),
          _viewInfo(),
          _viewBio(),
        ],
      ),
    );
  }

  _viewBio() {
    return (userbio != null && userbio!.isNotEmpty)
        ? Text(
            userbio ?? '',
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.txtColor4,
            ),
            maxLines: 3,
            textAlign: TextAlign.start,
            //overflow: TextOverflow.ellipsis,
          )
        : Container();
  }

  Row _viewInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextView(
          text: userId,
          padding: EdgeInsets.zero,
          sizeText: 11,
          colorText: AppColor.txtColor4,
          textAlign: TextAlign.start,
        ),
        TextView(
          text: rate,
          weightText: FontWeight.bold,
          padding: EdgeInsets.zero,
          sizeText: 10,
          colorText: AppColor.txtColor4,
          textAlign: TextAlign.start,
        ),
        Row(
          children: [
            ..._iconsView(12),
          ],
        )
      ],
    );
  }

  _viewName() {
    return UserNameView(
      typeUser: _getUserType(),
      isCertified: !isStudent && isCertified,
      child: SizedBox(
        width: 100,
        child: TextView(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: userName == ' ' ? fullName : userName,
          weightText: FontWeight.bold,
          padding: EdgeInsets.zero,
          sizeText: 16,
          colorText: AppColor.txtColor4,
        ),
      ),
    );
  }

  _userImage() {
    return Center(
      child: CachedImage(
        url: userImg,
        raduis: 27.5,
      ),
    );
  }

  List<Widget> _iconsView(double size) {
    return [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          Icons.star_border,
          color: AppColor.iconColor3,
          size: size,
        ),
      ),
      InkWell(
        onTap: () {
          //  cubit.markAsFavTeacher(id:cubit.teachers!);
          setFav!();
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            (isFav ?? false) ? (Icons.favorite) : (Icons.favorite_border),
            color: (isFav ?? false) ? Colors.red : AppColor.iconColor,
            size: size,
          ),
        ),
      ),
    ];
  }

  _getUserType() {
    if (!isStudent) {
      return isCertified ? TypeUser.paidTeacher : TypeUser.approvedTeacher;
    } else {
      return TypeUser.student;
    }
  }
}
