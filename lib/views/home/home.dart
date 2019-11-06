import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwel_smart/views/account/account.dart';
import 'package:jwel_smart/views/add/add_ad.dart';
import 'package:jwel_smart/views/add/my_ads.dart';
import 'package:jwel_smart/views/add/my_reseved_ads.dart';
import 'package:jwel_smart/views/add/recent.dart';
import 'package:jwel_smart/views/helpers/app_navigator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage;
  @override
  void initState() {
    currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jwel Smart'),
        centerTitle: true,
      ),
      drawer: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CommonDrawer(
                children: <Widget>[
                  CommonDrawerListTile(
                    title: "Account",
                    subtitle: "View your account details",
                    icon: MdiIcons.account,
                    onPressed: () {
                      AppNavigator.push(context, (_) => AccountView());
                    },
                  ),
                  CommonDrawerListTile(
                    title: "My Ads",
                    subtitle: "Your advertisements",
                    icon: MdiIcons.newspaper,
                    onPressed: () {
                      AppNavigator.push(context, (_) => MyAdsGrid());
                    },
                  ),
                  CommonDrawerListTile(
                    title: "My Reserved Ads",
                    subtitle: "Ads that you have reserved",
                    icon: MdiIcons.cart,
                    onPressed: () {
                      AppNavigator.push(context, (_) => MyReservedAdsGrid());
                    },
                  ),
                  CommonDrawerListTile(
                    title: "Verify advertisements",
                    subtitle: "Verify other advertisements",
                    icon: MdiIcons.security,
                    onPressed: () {},
                  ),
                  CommonDrawerListTile(
                    title: "Request admin",
                    subtitle: "Request administrator rights",
                    icon: MdiIcons.accountSupervisorCircle,
                    onPressed: () async {
                      String url =
                          "mailto:admin@jwelsmart.com?subject=Requesting permission to administrator rights&body=State reason here";
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                  ),
                ],
                email: snapshot.data.uid,
                username: snapshot.data.email,
                imageProvider: NetworkImage(
                    "https://i.pinimg.com/originals/1f/26/30/1f26303406294d9ee58da76e6d5d97be.jpg"),
                avatar: CircleAvatar(
                  child: Icon(MdiIcons.account),
                ),
              );
            }
            return Container();
          }),
      body: RecentAdGrid(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add ad"),
        onPressed: () {
          AppNavigator.push(context, (_) => AddAdView());
        },
      ),
    );
  }
}
