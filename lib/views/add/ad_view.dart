import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwel_smart/logic/home_page_queries.dart';
import 'package:jwel_smart/logic/objects/ad.dart';
import 'package:jwel_smart/logic/objects/user.dart';
import 'package:jwel_smart/logic/reserve.dart';
import 'package:jwel_smart/views/helpers/alert.dart';
import 'package:jwel_smart/views/helpers/handled_builders.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AdView extends StatelessWidget {
  final Ad ad;
  final bool isMyReservedAd;

  AdView({Key key, this.ad, this.isMyReservedAd = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("About Ad"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: HandledFutureBuilder<String>(
              future: HomePageQueries.getImageUrl(ad),
              builder: (_, imageUrl) => ad.imageId == null
                  ? Container()
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            height: mediaQueryWidth / 2,
            color: Theme.of(context).accentColor,
          ),
          Column(
            children: <Widget>[
              _buildListTile(MdiIcons.cart, ad.name, "Product", context),
              _buildListTile(
                  MdiIcons.coin, "LKR ${ad.price.toInt()}", "Price", context),
              _buildListTile(MdiIcons.text, "Description",
                  "Press here to see description", context, callback: () {
                Alert.showAlertBox(context, ad.description);
              }),
              _buildListTile(
                  MdiIcons.calendar,
                  ad.timestamp.toDate().toIso8601String(),
                  "Order added on",
                  context),
              _buildListTile(
                  MdiIcons.information,
                  ad.reserved ? "Reserved" : "Not Reserved",
                  "Ad state",
                  context),
              _buildListTile(
                  MdiIcons.checkboxMarkedCircle,
                  ad.verified ? "Verified" : "Not Verified",
                  "Ad verification state",
                  context),
              if (ad.reserved && !isMyReservedAd) ...[
                Divider(),
                _buildTitle("Reserved By"),
                HandledFutureBuilder<User>(
                    future: Reserve.getReservedUser(ad),
                    builder: (context, user) {
                      return Column(
                        children: <Widget>[
                          _buildListTile(MdiIcons.accountCircle, user.username,
                              "Reserved Person Username", context),
                          _buildListTile(
                              MdiIcons.phone,
                              user.phone,
                              "Reserved Person Phone Number",
                              context, callback: () {
                            _launchURL("tel:${user.phone}");
                          }),
                          _buildListTile(MdiIcons.email, user.email,
                              "Reserved Person Email", context, callback: () {
                            _launchURL("mailto:${user.email}");
                          }),
                        ],
                      );
                    }),
              ]
            ],
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (snapshot != null &&
                snapshot.hasData &&
                snapshot.data != null &&
                !ad.reserved &&
                snapshot.data.uid != ad.ownerId) {
              return FloatingActionButton.extended(
                icon: Icon(MdiIcons.coins),
                label: Text("Reserve"),
                onPressed: () async {
                  bool confirm = await Alert.showYesNoBox(
                      context, "Are you sure you want to reserve?");
                  if (!confirm) return;
                  try {
                    await Reserve.reserve(ad, snapshot.data.uid);
                    Navigator.pop(context);
                  } catch (e) {
                    Alert.showAlertBox(context, e.toString());
                  }
                },
              );
            }
            if (isMyReservedAd) {
              return FloatingActionButton.extended(
                icon: Icon(MdiIcons.cancel),
                label: Text("Unreserve"),
                onPressed: () async {
                  bool confirm = await Alert.showYesNoBox(
                      context, "Are you sure you want to unreserve?");
                  if (!confirm) return;
                  try {
                    await Reserve.unreserve(ad, snapshot.data.uid);
                    Navigator.pop(context);
                  } catch (e) {
                    Alert.showAlertBox(context, e.toString());
                  }
                },
              );
            }
            return Container();
          }),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, bottom: 0.0, top: 20.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(
      IconData icon, String title, String subtitle, BuildContext context,
      {VoidCallback callback}) {
    return ListTile(
        leading: Icon(icon, color: Theme.of(context).accentColor),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onTap: callback,
        subtitle: Text(subtitle),
        trailing: callback != null ? Icon(MdiIcons.chevronRight) : null);
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
