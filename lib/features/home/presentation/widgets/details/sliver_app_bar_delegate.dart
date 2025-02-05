import 'package:flutter/material.dart';

class MySliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  MySliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverAppBarDelegate oldDelegate) => false;
}