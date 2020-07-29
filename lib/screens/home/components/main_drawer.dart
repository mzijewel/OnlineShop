import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/screens/fav/fav_screen.dart';
import 'package:flutter_onlie_shop/screens/myOrder/my_order_screen.dart';
import 'package:flutter_onlie_shop/service/auth_service.dart';

class MainDrawer extends StatelessWidget {
  final String email, name, photoUrl;

  const MainDrawer({Key key, this.email, this.name, this.photoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    return new Drawer(
        child: Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Scrollbar(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  height: 150,
                  color: Colors.teal,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: photoUrl.isNotEmpty
                                          ? Image.network(
                                              photoUrl,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.fill,
                                            )
                                          : Icon(Icons.person_pin),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              email ?? '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            Text(name ?? '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                ListTile(
//                  selected: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyOrderScreen(),
                    ));
                  },
                  leading: Icon(Icons.iso),
                  title: Text("My Order"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.settings_overscan),
                  title: Text("Shop"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavScreen(),
                        ));
                  },
                  leading: Icon(Icons.share),
                  title: Text("My Fav"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.share),
                  title: Text("Share App"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.rate_review),
                  title: Text("Rate it!"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.report),
                  title: Text("Report"),
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.apps),
                  title: Text("About App"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.thumb_up),
                  title: Text("Like us on Facebook"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.help),
                  title: Text("Privacy Policy"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _authService.signOut(context);
                  },
                  leading: Icon(Icons.person_pin),
                  title: Text("Logout"),
                ),
              ],
            ))));
  }
}
