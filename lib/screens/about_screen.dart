import 'package:achivment_game/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static final String id = 'AboutScreen';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('About the App'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: screenHeight * 0.15,
              height: screenHeight * 0.15,
              child: FittedBox(
                child: Image.asset(
                  'images/appIcon.jpg',
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) {
                return RadialGradient(
                  center: Alignment.topCenter,
                  radius: 5.0,
                  colors: [
                    Colors.deepOrange,
                    Colors.yellow,
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                'Achievement Game',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                '1.0.0',
                textAlign: TextAlign.center,
                style: kAboutScreenTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'The main goal of this app is to help you adding gamification to your '
                'plan to get things done'
                '\n\n1. You start by giving the number of weeks you want to plan for.. '
                'then you can add goals anf give points to every goal'
                '\n\n2. Once you have worked on a goal and achieved something then you can '
                'go to the tracking screen and add that to your achievement'
                '\n\n3. You need also to add some rewards to yourself that you can buy '
                'with the points you have achieved'
                '\n\nThe app can also help you adding reminders and steps to your goals'
                '\n\nYou can restart the game whenever you want but you will lose the data',
                style: kAboutScreenTextStyle,
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Achievement Game is ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String url =
                              'https://www.youtube.com/user/flashawy/videos';
                          await launch(url);
                        },
                      text: 'Ali Muhammed Ali',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(
                      text: "'s idea and was turned into an app by ",
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri _emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'husssamhamo123@gmail.com',
                              queryParameters: {'subject': ''});
                          await launch(_emailLaunchUri.toString());
                        },
                      text: 'Husam Hamu',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.orange,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                text: const TextSpan(
                  children: [
                    const TextSpan(
                      text: 'For your suggestions:  ',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
