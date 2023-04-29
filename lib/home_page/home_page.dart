import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/constants.dart';

import 'package:responsive_builder/responsive_builder.dart';

import '../notificationservice/local_notification_service.dart';
import '../widget/Custom_Buttons.dart';
import '../widget/custom_appBar.dart';
import 'data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _post = Data.postList;
  bool _showAppNavBar = true;
  ScrollController _scrollController;
  bool _isScrollDown = false;

  @override
  void initState() {
    super.initState();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          //? in a place of ! in the below 2 line
          print(message.notification?.title);
          print(message.notification?.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          //? in a place of ! in the below 2 line
          print(message.notification?.title);
          print(message.notification?.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();
  //   _initialScroll();
  // }

  void _initialScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollDown) {
          _isScrollDown = true;
          _hideAppNavBar();
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollDown) {
          _isScrollDown = false;
          _showAppNvBar();
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (BuildContext context, SizingInformation sizingInformation) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.black12,
            child: Column(
              children: [
                _showAppNavBar
                    ? CustomAppBar(
                        sizingInformation: sizingInformation,
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
                _listPostWidget(sizingInformation),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _listPostWidget(SizingInformation sizingInformation) {
    return Expanded(
        child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _post.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            margin: EdgeInsets.only(bottom: 0.0, top: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.black54, width: 0.50),
                    bottom: BorderSide(color: Colors.black54, width: 0.50))),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(Radius.circular(0)),
                          image: DecorationImage(
                              image: AssetImage(_post[index].profileUrl))),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _post[index].name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: sizingInformation.screenSize.width / 1.34,
                          child: Text(
                            _post[index].headline,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _post[index].description,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  _post[index].tags,
                  style: TextStyle(color: kPrimaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: sizingInformation.screenSize.width,
                  child: Image.asset(
                    _post[index].image,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                              width: 25,
                              height: 25,
                              child: Image.asset('assets/icons/like_icon.png')),
                          Container(
                              width: 25,
                              height: 25,
                              child: Image.asset(
                                  'assets/icons/celebrate_icon.png')),
                          if (index == 0 || index == 4 || index == 6)
                            Container(
                                width: 25,
                                height: 25,
                                child:
                                    Image.asset('assets/icons/love_icon.png')),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _post[index].likes,
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(_post[index].comments),
                          Text(" comments")
                        ],
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 0.50,
                  color: Colors.black26,
                ),
                _rowButton(),
              ],
            ),
          );
        },
      ),
    ));
  }

  void _hideAppNavBar() {
    setState(() {
      _showAppNavBar = false;
    });
  }

  void _showAppNvBar() {
    setState(() {
      _showAppNavBar = true;
    });
  }

  Widget _rowButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: rowSingleButton(
                color: Colors.black,
                name: "Like",
                iconImage: "assets/icons/like_icon_white.png",
                isHover: false),
          ),
          InkWell(
            onTap: () {},
            child: rowSingleButton(
                color: Colors.black,
                name: "Comment",
                iconImage: "assets/icons/comment_icon.png",
                isHover: false),
          ),
          InkWell(
            onTap: () {},
            child: rowSingleButton(
                color: Colors.black,
                name: "Share",
                iconImage: "assets/icons/share_icon.png",
                isHover: false),
          ),
        ],
      ),
    );
  }
}
