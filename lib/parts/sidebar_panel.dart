import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBarPanel extends StatelessWidget {
  const SideBarPanel({super.key});




  Future<void> _launchUrl(String urlTarget) async {
    Uri url = Uri.parse(urlTarget);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/3),
        decoration: BoxDecoration(
          color: Colors.black54.withOpacity(.4),
          //borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(500, 150),topRight: Radius.circular(10))
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/logo.png'),
                            fit: BoxFit.fitWidth,
                            opacity: .6)),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(top: 40),
                    child: const Text(
                      'Morteza Lotfi G',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Align(
                      heightFactor: 1.7,
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        radius: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 48,
                          child: Icon(
                            Icons.person,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          _launchUrl('https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                        },
                        icon: const Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.telegram,
                          color: Colors.white,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.twitter,
                          color: Colors.white,
                          size: 30,
                        )),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.all(20).copyWith(right: 100),
                    child: Image.asset(
                      'images/mlggrand.png',
                      width: 50,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
