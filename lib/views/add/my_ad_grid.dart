import 'package:flutter/material.dart';
import 'package:jwel_smart/logic/home_page_queries.dart';
import 'package:jwel_smart/logic/objects/ad.dart';
import 'package:jwel_smart/views/add/ad_view.dart';
import 'package:jwel_smart/views/helpers/app_navigator.dart';
import 'package:jwel_smart/views/helpers/handled_builders.dart';

class MyAdGrid extends StatelessWidget {
  final List<Ad> ads;

  const MyAdGrid({Key key, @required this.ads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        Ad ad = ads[index];

        return Card(
          child: Material(
            child: InkWell(
              onTap: () => AppNavigator.push(context, (_) => AdView(ad: ad)),
              child: GridTile(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: ad.imageId == null
                          ? Container(color: Colors.indigo)
                          : HandledFutureBuilder<String>(
                              future: HomePageQueries.getImageUrl(ad),
                              builder: (_, imageUrl) => Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    if (ad.reserved)
                      Center(
                        child: Chip(
                          backgroundColor: Colors.amber[800],
                          label: Text("RESERVED",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w800)),
                        ),
                      ),
                  ],
                ),
                footer: Container(
                  height: 30.0,
                  color: Colors.black87,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ad.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
