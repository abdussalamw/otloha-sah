import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 20, thickness: 1.2);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التواصل مع الإدارة والروابط'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCard(
                title: 'معلومات التواصل',
                children: [
                  _buildInfoTile(
                    Icons.location_on,
                    'الشيخ محمد بن عبدالعزيز الراجحي لتعليم القرآن الكريم',
                    onTap: () =>
                        _launchURL('https://maps.app.goo.gl/ZyE4Mt5ZvtiNUmmk6'),
                  ),
                  _buildInfoTile(Icons.phone, '+966533422404',
                      onTap: () => _launchURL('tel:+966533422404')),
                  _buildInfoTile(Icons.email, 'RAcademy@qj.org.sa',
                      onTap: () => _launchURL('mailto:RAcademy@qj.org.sa')),
                  _buildInfoTile(Icons.mail_outline, 'mbnoob@qj.org.sa',
                      onTap: () => _launchURL('mailto:mbnoob@qj.org.sa')),
                ],
              ),
              _buildCard(
                title: 'قنوات التواصل الاجتماعي',
                children: [
                  _buildInfoTile(Icons.video_library, 'يوتيوب',
                      onTap: () =>
                          _launchURL('https://www.youtube.com/user/khayrocom')),
                  _buildInfoTile(Icons.camera_alt, 'انستجرام',
                      onTap: () =>
                          _launchURL('https://www.instagram.com/khayrocom/')),
                  _buildInfoTile(Icons.facebook, 'فيسبوك',
                      onTap: () =>
                          _launchURL('https://www.facebook.com/khayrocom')),
                  _buildInfoTile(Icons.alternate_email, 'حساب X (تويتر)',
                      onTap: () => _launchURL('https://x.com/khayrocom')),
                  _buildInfoTile(
                    Icons.volunteer_activism,
                    'التبرعات',
                    onTap: () => _launchURL('https://qjstore.org.sa/projects'),
                  ),
                ],
              ),
              _buildCard(
                title: 'خدمات خيركم التعليمية',
                children: [
                  _buildInfoTile(Icons.apps, 'عرض التطبيقات المتاحة وتنزيلها',
                      onTap: () =>
                          _launchURL('https://alrajhiacademy.com/ar/services')),
                  _buildInfoTile(Icons.web, 'منصة خيركم',
                      onTap: () => _launchURL('https://qjstore.org.sa/')),
                ],
              ),
              _buildCard(
                title: 'برنامج التطوع',
                children: [
                  _buildInfoTile(Icons.volunteer_activism, 'تعبئة نموذج التطوع',
                      onTap: () => _launchURL(
                          'https://www.qj.org.sa/index.php?op=volunteer')),
                ],
              ),
              _buildCard(
                title: 'الدورات التدريبية',
                children: [
                  _buildInfoTile(Icons.school, 'رابط التسجيل في الدورات',
                      onTap: () => _launchURL(
                          'https://alrajhiacademy.com/ar/services/%D8%AF%D9%88%D8%B1%D8%A7%D8%AA-%D8%AA%D8%AC%D9%88%D9%8A%D8%AF-%D8%A3%D9%88%D9%86%D9%84%D8%A7%D9%8A%D9%86-1734430835')),
                ],
              ),
              _buildCard(
                title: 'المقارئ',
                children: [
                  _buildInfoTile(
                    Icons.phone_in_talk,
                    'المقرأة الهاتفية',
                    onTap: () => _launchURL(
                      'https://alrajhiacademy.com/ar/services/%D8%A7%D9%84%D9%85%D9%82%D8%B1%D8%A3%D8%A9-%D8%A7%D9%84%D9%87%D8%A7%D8%AA%D9%81%D9%8A%D8%A9-1734431484',
                    ),
                  ),
                  _buildInfoTile(
                    Icons.computer,
                    'الحلقات الإلكترونية',
                    onTap: () => _launchURL(
                      'https://alrajhiacademy.com/ar/services/%D8%A7%D9%84%D8%AD%D9%84%D9%82%D8%A7%D8%AA-%D8%A7%D9%84%D8%A5%D9%84%D9%83%D8%AA%D8%B1%D9%88%D9%86%D9%8A%D8%A9-1734430913',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
