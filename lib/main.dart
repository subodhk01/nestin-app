import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main()  {
  runApp(FinantialApp());
}

class FinantialApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Finantial App",
      home: HomePage( ),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String jsCode;
  int _selectedItem = 0;
  WebViewController controllerHome;
  WebViewController controllerListings;

//  var url = "https://alpha.nestin.io/";
  List<Widget> get webViews {
    return [
      WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controllerHome = controller;
        },
        onPageFinished: (url){

          controllerHome.evaluateJavascript(jsCode); // here comes the js code
        },
        initialUrl: "https://alpha.nestin.io/",
        key: UniqueKey(),
      ),
      WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controllerListings = controller;
        },
        onPageFinished: (url){
          controllerListings.evaluateJavascript('console.log("Subodh Chutiya2")'); // here comes the js code
        },
        initialUrl: "https://alpha.nestin.io/listings",
        key: UniqueKey(),
      ),
      Center(
        child: Text("HEll"),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        iconList: [
          Icons.home,
          Icons.map,
          Icons.person,
        ],
        onChange: (val) {
          setState(() {
            _selectedItem = val;
//              switch (_selectedItem) {
//                case 0:
//                  url = "https://alpha.nestin.io/";
//                  break;
//                case 1:
//                  url = "https://alpha.nestin.io/listings/";
//                  break;
//                default:
//              }
          });
        },
        defaultSelectedIndex: 0,
      ),
      body: FutureBuilder<String>(
        future:  rootBundle.loadString('assets/js/js_code.js'),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            jsCode = snapshot.data;
            return SafeArea(
              child: IndexedStack(
                index: _selectedItem,
                children: webViews,
              ),
            );
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }

        }
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
        @required this.iconList,
        @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / _iconList.length,
        decoration: index == _selectedIndex
            ? BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2, color: Colors.blue),
            ),
            gradient: LinearGradient(colors: [
              Colors.blue.withOpacity(0.3),
              Colors.blue.withOpacity(0.015),
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
          // color: index == _selectedItemIndex ? Colors.green : Colors.white,
        )
            : BoxDecoration(),
        child: Icon(
          icon,
          color: index == _selectedIndex ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}