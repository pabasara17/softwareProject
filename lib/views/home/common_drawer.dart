import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  final ImageProvider imageProvider;

  final String username;

  final String email;

  final Widget avatar;

  final Color imageOverlayColor;

  final int imageOverlayOpacity;

  final List<Widget> children;

  final List<Widget> bottomChildren;

  final Color avatarBackgroundColor;

  CommonDrawer({
    Key key,
    @required this.imageProvider,
    @required this.username,
    @required this.email,
    @required this.avatar,
    this.avatarBackgroundColor,
    this.imageOverlayColor = const Color(0x0),
    this.imageOverlayOpacity = 0xaa,
    this.children = const [],
    this.bottomChildren = const [],
  }) : super(key: key) {
    assert(0 <= imageOverlayOpacity && imageOverlayOpacity <= 0xff,
        "Image Overlay Opacity must be between 0 and 255.");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountEmail: Text(
              email,
              style: TextStyle(fontSize: 10),
            ),
            accountName: Text(username),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  imageOverlayColor.withAlpha(imageOverlayOpacity),
                  BlendMode.srcATop,
                ),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: avatar,
              backgroundColor: avatarBackgroundColor,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: children.length,
              itemBuilder: (_, index) => children[index],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: bottomChildren,
          )
        ],
      ),
    );
  }
}

class CommonDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final Color iconColor;

  const CommonDrawerListTile({
    Key key,
    @required this.icon,
    @required this.title,
    this.subtitle,
    this.onPressed,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      onTap: onPressed,
    );
  }
}
