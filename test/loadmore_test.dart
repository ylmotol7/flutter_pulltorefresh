/*
    Author: Jpeng
    Email: peng8350@gmail.com
    createTime: 2019-07-21 12:29
 */


import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'dataSource.dart';
import 'test_indicator.dart';



void main(){

  testWidgets("from bottom pull up release gesture to load more", (tester) async{
    final RefreshController _refreshController = RefreshController(
        initialRefresh: true);
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: SmartRefresher(
        header: TestHeader(),
        footer: TestFooter(),
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.builder(
          itemBuilder: (c, i) =>
              Center(
                child: Text(data[i]),
              ),
          itemCount: 20,
          itemExtent: 100,
        ),
        controller: _refreshController,
      ),
    ));
    _refreshController.position.jumpTo(_refreshController.position.maxScrollExtent-30);
    await tester.drag(find.byType(Scrollable), const Offset(0,-100.0));
    await tester.pump();
    expect(_refreshController.footerStatus, LoadStatus.idle);
    await tester.pump(Duration(milliseconds: 100));
    expect(_refreshController.footerStatus, LoadStatus.loading);
  });

  testWidgets("strick to check tigger judge", (tester) async{
    final RefreshController _refreshController = RefreshController(
        initialRefresh: true);
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: SmartRefresher(
        header: TestHeader(),
        footer: TestFooter(),
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.builder(
          itemBuilder: (c, i) =>
              Center(
                child: Text(data[i]),
              ),
          itemCount: 20,
          itemExtent: 100,
        ),
        controller: _refreshController,
      ),
    ));
    _refreshController.position.jumpTo(_refreshController.position.maxScrollExtent-216);
    await tester.drag(find.byType(Scrollable), const Offset(0,-200.0));
    await tester.pump();
    expect(_refreshController.footerStatus, LoadStatus.idle);
    await tester.pump(Duration(milliseconds: 100));
    expect(_refreshController.footerStatus, LoadStatus.idle);
  });

  testWidgets("far from bottom,flip to bottom by ballstic also can trigger loading", (tester) async{
    final RefreshController _refreshController = RefreshController(
        initialRefresh: true);
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: SmartRefresher(
        header: TestHeader(),
        footer: TestFooter(),
        enablePullUp: true,
        enablePullDown: true,
        child: ListView.builder(
          itemBuilder: (c, i) =>
              Center(
                child: Text(data[i]),
              ),
          itemCount: 20,
          itemExtent: 100,
        ),
        controller: _refreshController,
      ),
    ));
    _refreshController.position.jumpTo(_refreshController.position.maxScrollExtent-500);
    await tester.fling(find.byType(Scrollable), const Offset(0,-300.0),2200);
    await tester.pump();
    expect(_refreshController.footerStatus, LoadStatus.idle);
    while (tester.binding.transientCallbackCount > 0) {
      //15.0 is default
      if(_refreshController.position.extentAfter<15){
        expect(_refreshController.footerStatus, LoadStatus.loading);
      }
      else{
        expect(_refreshController.footerStatus, LoadStatus.idle);
      }
      await tester.pump(const Duration(milliseconds: 20));
    }

  });
}