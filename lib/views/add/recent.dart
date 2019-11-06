import 'package:flutter/material.dart';
import 'package:jwel_smart/logic/home_page_queries.dart';
import 'package:jwel_smart/logic/objects/ad.dart';
import 'package:jwel_smart/views/add/ad_grid.dart';
import 'package:jwel_smart/views/helpers/handled_builders.dart';

class RecentAdGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HandledStreamBuilder<List<Ad>>(
        stream: HomePageQueries.recent(),
        builder: (context, ads) {
          return AdGrid(ads: ads);
        });
  }
}
