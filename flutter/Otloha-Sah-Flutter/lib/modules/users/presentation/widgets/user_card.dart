// import 'package:flutter/material.dart';
// import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
// import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
// import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
// import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/student_to_student_btn.dart';

// class UserCard extends StatelessWidget {
//   const UserCard({super.key, required this.user});
//   final BaseUser user;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             CachedImage(url: user.image ?? '', raduis: 35),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Text(
//                           user.username,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         color: Color(0xffFF9D2B),
//                         size: 16,
//                       ),
//                       const SizedBox(width: 2),
//                       Text(
//                         user.rate,
//                         style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         user.narration ?? '',
//                         style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             // if (!user.isTeacher && !UserDataServices.instance.isATeacher)
//             //   StudentToStudentBtn(userId: user.id),
//           ],
//         ),
//         Divider(
//           color: Colors.grey[200]!,
//           indent: 80,
//         ),
//       ],
//     );
//   }
// }
