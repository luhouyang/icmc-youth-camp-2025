import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yc_icmc_2025/pages/auth/small_login_page.dart';
import 'package:yc_icmc_2025/states/constants.dart';
import 'package:yc_icmc_2025/widgets/texts/snack_bar_text.dart';

class SmallAboutPage extends StatelessWidget {
  const SmallAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrlAsync(String urlString) async {
      final Uri url = Uri.parse(urlString);

      if (!await launchUrl(url)) {
        if (context.mounted) {
          SnackBarText().showBanner(msg: 'Could not launch $url', context: context);
        }
        throw Exception('Could not launch $url');
      }
    }

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
                  "Some long long text Some long long text Some long long text Some long long text Some long long textSome long long text Some long long text Some long long text Some long long text",
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
