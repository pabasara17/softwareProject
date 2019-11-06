import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwel_smart/logic/home_page_queries.dart';
import 'package:jwel_smart/logic/objects/ad.dart';
import 'package:jwel_smart/views/helpers/handled_builders.dart';

import 'my_ad_grid.dart';

class MyAdsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ads"),
      ),
      body: HandledFutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, auth) {
            return HandledStreamBuilder<List<Ad>>(
                stream: HomePageQueries.myAds(auth.uid),
                builder: (context, ads) {
                  return MyAdGrid(ads: ads);
                });
          }),
    );
  }
}
