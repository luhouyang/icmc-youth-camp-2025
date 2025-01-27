import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:yc_icmc_2025/pages/auth/small_login_page.dart';
import 'package:yc_icmc_2025/states/constants.dart';
// import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';

class SmallAboutPage extends StatelessWidget {
  const SmallAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Future<void> launchUrlAsync(String urlString) async {
    //   final Uri url = Uri.parse(urlString);

    //   if (!await launchUrl(url)) {
    //     if (context.mounted) {
    //       SnackBarText().showBanner(msg: 'Could not launch $url', context: context);
    //     }
    //     throw Exception('Could not launch $url');
    //   }
    // }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(Constants().smallScreenPadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/profile_placeholder.jpg',
                  scale: 3.5,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Youth Camp",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 16,
                  width: 16,
                ),
                Text(
                  "日期:1/4/2025 至 4/4/2025(4 天三夜)\n地点:怡保堂卫理幼儿园\n对象:青少年 13-18 岁(开放给信徒/非信徒的华裔,12 岁勉强接受)\n营会概念及宗旨:帮助营员认识自己的价值观、自我,并加强合作精神与信仰认知\n主题:《我是谁?》\n营费:RM 100",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 18,
                ),
                const Divider(),
                const SmallLoginPage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
