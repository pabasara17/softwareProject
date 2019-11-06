import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwel_smart/logic/home_page_queries.dart';
import 'package:jwel_smart/logic/objects/ad.dart';
import 'package:jwel_smart/views/add/ad_grid.dart';
import 'package:jwel_smart/views/helpers/handled_builders.dart';

class MyReservedAdsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reserved Ads"),
      ),
      body: HandledFutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, auth) {
            return HandledStreamBuilder<List<Ad>>(
                stream: HomePageQueries.myReservedAds(auth.uid),
                builder: (context, ads) {
                  return AdGrid(
                    ads: ads,
                    isMyReservedAds: true,
                  );
                });
          }),
    );
  }
}
