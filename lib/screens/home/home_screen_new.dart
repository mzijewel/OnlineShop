import 'dart:async';

import 'package:badges/badges.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/details/details_screen.dart';
import 'package:flutter_onlie_shop/screens/home/components/body.dart';
import 'package:flutter_onlie_shop/screens/home/components/item_card.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen.dart';
import 'package:flutter_onlie_shop/screens/login/login_screen.dart';
import 'package:flutter_onlie_shop/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:flutter_onlie_shop/service/auth_service.dart';
import 'package:flutter_onlie_shop/utilities/global.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/image_slider.dart';
import 'components/main_drawer.dart';

class HomeScreenNew extends StatefulWidget {
  @override
  _HomeScreenNewState createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew>
    with SingleTickerProviderStateMixin, RouteAware {
  TabController _tabController;
  ScrollController _scrollController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, name, photoUrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<MCartItem>> _list;
  List<MCartItem> data = [];
  AppDatabase db;
  int cartSize = 0;
  bool _isShake = false;
  List<String> categories = ["HandBags", "Jewellery", "Footwear", "Dresses"];
  PageController controller = PageController();
  int selectedIndex = 0;

  initDb() async {
//    final migration1to2 = Migration(1, 2, (database) async {
//      await database.execute('ALTER TABLE MOrder ADD COLUMN *');
//    });
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getData();
  }

  void getData() {
    _list = db.myDao.getCartItems();
    _list.then((value) {
      setState(() {
        data = value;
//        cartSize = value.length;
        var cartItem = Provider.of<CartItem>(context, listen: false);
        cartItem.updateCartSize(data.length);
      });
    });
  }

  void save(String title, int price, int id, int cartQuantity, String image) {
    MCartItem person = MCartItem(
        title: title,
        price: price,
        id: id,
        catQuantity: cartQuantity,
        image: image);
    db.myDao.insertCart(person);
    getData();
  }

  bool _hasCart(int id) {
    for (int i = 0; i < data.length; i++) {
      if (data[i].id == id) {
        return true;
      }
    }
    return false;
  }

  void onPageChanged(int page) {
    setState(() {
      this.selectedIndex = page;
    });
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        print(index);
        this.controller.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceOut);
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? kTextColor : kTextLightColor),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPadding / 4),
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.brown : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  getUser() async {
    await _auth.currentUser().then((value) {
      print(value.email);
      setState(() {
        name = value.displayName;
        email = value.email;
      });
    });
  }

  getDataFromFireStore() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("Users")
        .document(firebaseUser.uid)
        .get()
        .then((value) {
      print(value.data["photoUrl"]);
      setState(() {
        photoUrl = value.data["photoUrl"];
      });
    });
  }

  getRealTimeData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('Users')
        .document(firebaseUser.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        print("run data: ${event.data["phone"]}");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    controller = new PageController(
      initialPage: selectedIndex,
    );
    controller.addListener(() {
      setState(() {});
    });
    getUser();
    getDataFromFireStore();
    initDb();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Global.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  // Called when the top route has been popped off, and the current route shows up.
  @override
  void didPopNext() {
    super.didPopNext();
    getUser();
    getDataFromFireStore();
    initDb();
  }

  // Called when the current route has been pushed.
  @override
  void didPush() {
    super.didPush();
  }

  // Called when the current route has been popped off.
  @override
  void didPop() {
    super.didPop();
  }

  // Called when a new route has been pushed, and the current route is no longer visible.
  @override
  void didPushNext() {
    super.didPushNext();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    Global.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        key: _scaffoldKey,
        appBar: buildAppBar(context),
        body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: ImageSlider(),
                  ),
                  pinned: false,
                  automaticallyImplyLeading: false,
                  floating: true,
                  expandedHeight: 200,
                  forceElevated: boxIsScrolled,
//                  bottom: TabBar(
//                    tabs: <Widget>[
//                      Tab(
//                        text: "Home",
//                        icon: Icon(Icons.home),
//                      ),
//                      Tab(
//                        text: "card_travel",
//                        icon: Icon(Icons.card_travel),
//                      )
//                    ],
//                    controller: _tabController,
//                  ),
                ),
              ];
            },
            body: _PageViewWithItemCart()),
        drawer: SafeArea(
            child: MainDrawer(
          name: name,
          email: email,
          photoUrl: photoUrl,
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openMessenger(),
          label: Text("Message Us"),
          icon: Icon(Icons.message),
        ),
      ),
    );
  }

  _openMessenger() async {
    var messengerUrl = "m.me/nurulislam.nayan.3";
    await canLaunch("http://$messengerUrl")
        ? launch("http://$messengerUrl")
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }
  _openFB() async {
    var messengerUrl = "facebook.com/nurulislam.nayan.3";
//    var messengerUrl = "fb.me/nurulislam.nayan.3";
    await canLaunch("http://$messengerUrl")
        ? launch("http://$messengerUrl")
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  _openWhatsApp() async {
    var whatsappUrl = "whatsapp://send?phone=+8801770336603";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'smith@example.com',
      queryParameters: {'subject': 'Example Subject & Symbols are allowed!'});

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch('tel:01770336603')) {
      await launch('tel:01770336603');
    } else {
      throw 'Could not launch $url';
    }
  }

  Column _PageViewWithItemCart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            "Women",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: 10),
          child: PageView.builder(
            onPageChanged: onPageChanged,
            controller: controller,
            itemBuilder: (context, position) {
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: kDefaultPadding,
                    crossAxisSpacing: kDefaultPadding),
                itemBuilder: (context, index) => Consumer<CartItem>(
                  builder:
                      (BuildContext context, CartItem value, Widget child) {
                    return ItemCard(
                      cartTitle: _hasCart(products[index].id)
                          ? "Remove from cart"
                          : "Add to cart",
                      product: products[index],
                      press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<CartItem>(
                                    create: (BuildContext context) =>
                                        CartItem(),
                                    child: DetailsScreen(
                                      product: products[index],
                                    ),
                                  ))),
                      addCart: () {
                        if (_hasCart(products[index].id)) {
                          db.myDao.deleteCart(products[index].id);
                          getData();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Remove from cart'),
                            duration: Duration(seconds: 1),
                          ));
                        } else {
                          save(
                              products[index].title,
                              products[index].price,
                              products[index].id,
                              value.productQuantity != null &&
                                      value.productQuantity > 0
                                  ? value.productQuantity
                                  : 1,
                              products[index].image);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Added to cart'),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      },
                    );
                  },
                ),
              );
            },
            itemCount: categories.length,
          ),
        ))
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    FacebookLogin facebookSignIn = new FacebookLogin();
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    Future<void> _fbLogOut() async {
      await facebookSignIn.logOut();
    }

    Future<void> _googleSignOut() => _googleSignIn.disconnect();

    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Online Shop",
        style: TextStyle(color: Colors.teal),
      ),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.brown,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: null),
        Consumer<CartItem>(
          builder: (BuildContext context, CartItem value, Widget child) {
            if (value.cartSize != null) {
              if (cartSize != value.cartSize) {
                _isShake = true;
                print(_isShake);
                if (_isShake) {
                  Timer(Duration(seconds: 1), () {
                    setState(() {
                      _isShake = false;
                    });
                    print(_isShake);
                  });
                } else
                  _isShake = false;
              }
              cartSize = value.cartSize;
            } else
              cartSize = data.length;

            return Badge(
              position: BadgePosition.topRight(top: 0, right: 3),
              animationDuration: Duration(seconds: 2),
              animationType: BadgeAnimationType.slide,
              showBadge: cartSize > 0,
              badgeContent: Text(
                cartSize.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: ShakeAnimatedWidget(
                  enabled: _isShake,
                  duration: Duration(milliseconds: 300),
                  shakeAngle: Rotation.deg(z: 40),
                  curve: Curves.linear,
                  child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.brown,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<CartItem>(
                                create: (BuildContext context) => CartItem(),
                                child: ShoppingCartScreen(),
                              ),
                            ));
                      })),
            );
          },
        ),
        SizedBox(
          width: kDefaultPadding / 2,
        )
      ],
    );
  }
}
