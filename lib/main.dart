import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'utils/main_constant.dart';
import 'views/categoryscreen.dart';
import 'views/homescreen.dart';
import 'views/post_detail_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then(
          (_) {
        runApp(MyApp());
      });
}

const HomeItemTitle = [
  'home',
  'kategori',
  'akun'
];
const HomeItemIcon = [
  Icons.home,
  Icons.category,
  Icons.account_circle
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartphoneku',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      initialRoute: ROUTE_DEFAULT,
      routes: {
        ROUTE_DEFAULT: (context) => Scaffold(
          backgroundColor: Colors.white,
          body: MyHomePage(),
        ),
        ROUTE_POST_DETAIL: (context) => PostDetailPage(),
//        ROUTE_SEARCH_PAGE: (context) => SearchPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static _HomePageState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_HomePageState>());

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => _HomePageState();
}

const TAB_ITEM_COUNT = 3;

class _HomePageState extends State<MyHomePage>{
  int curItemType = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Image.asset('assets/zona284.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover
            ),
          ),
        ),
        body: _itemBody(curItemType),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: curItemType,
          items: _homeItem(),
          onTap: selectItem,
        )
    );
  }

  List<BottomNavigationBarItem> _homeItem(){
    return [
      BottomNavigationBarItem(
          icon: Icon(HomeItemIcon[0]),
          title: Text(HomeItemTitle[0])
      ),

      BottomNavigationBarItem(
          icon: Icon(HomeItemIcon[1]),
          title: Text(HomeItemTitle[1])
      ),
//todo hide sementara
//      BottomNavigationBarItem(
//          icon: Icon(HomeItemIcon[2]),
//          title: Text(HomeItemTitle[2])
//      )
    ];
  }

  Widget _itemBody(index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return CategoryScreen();
//todo hide sementara
//      case 2:
//        return AccountScreen();
      default:
        return HomeScreen();
    }
  }

  void selectItem(index) {
    setState(() {
      curItemType = index;
    });
  }

}
