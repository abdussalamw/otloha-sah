import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';

class HonorBoardPage extends StatefulWidget {
  final String type; // 'student' or 'teacher'

  const HonorBoardPage({super.key, required this.type});

  @override
  State<HonorBoardPage> createState() => _HonorBoardPageState();
}

class _HonorBoardPageState extends State<HonorBoardPage> {
  List<BaseUser> topUsers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTopUsers();
  }

  Future<void> fetchTopUsers() async {
    setState(() => loading = true);

    final endpoint = widget.type == 'teacher'
        ? '/api/v2/users-profiles/teachers/'
        : '/api/v2/users-profiles/students/';

    try {
      final response = await ApiBaseHelper().getHTTP(
        endpoint,
        queryParameters: {'page': 1, 'ordering': '-rate'},
        dioTypes: DioTypes.authRequired,
      );

      final results = response?.data['results'] as List;

      setState(() {
        topUsers = results.map((e) {
          if (widget.type == 'teacher') {
            return BaseUser.fromMap(e);
          } else {
            return BaseUser.fromMap(e);
          }
        }).toList();
      });
    } catch (e) {
      print('Error fetching ${widget.type}s: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Widget buildUserTile(BaseUser user, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.image != null && user.image!.isNotEmpty
            ? NetworkImage(user.image!)
            : const AssetImage('assets/images/default_user.png')
                as ImageProvider,
      ),
      title: Text(
        user.username,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'التقييم: ${user.rate}',
        textDirection: TextDirection.rtl,
      ),
      trailing: CircleAvatar(
        backgroundColor: Colors.amber.shade700,
        child: Text('${index + 1}'),
      ),
      onTap: () {
        // Example navigation based on type and user id
        if (widget.type == 'teacher') {
          Navigator.pushNamed(context, '/teacher/${user.id}');
        } else {
          Navigator.pushNamed(context, '/student/${user.id}');
        }
      },
    );
  }

  String getPageTitle() {
    return widget.type == 'teacher' ? 'المعلمين المميزين' : 'أفضل الطلاب';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(getPageTitle()),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: topUsers.length,
                itemBuilder: (context, index) =>
                    buildUserTile(topUsers[index], index),
                separatorBuilder: (_, __) => const Divider(),
              ),
      ),
    );
  }
}
