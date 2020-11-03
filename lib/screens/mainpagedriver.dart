import 'package:flutter/material.dart';
import 'package:workavane/brand_colors.dart';
import 'package:workavane/tabs/earningstab.dart';
import 'package:workavane/tabs/hometab.dart';
import 'package:workavane/tabs/profiletab.dart';
import 'package:workavane/tabs/ratingstab.dart';

class MainPageDriver extends StatefulWidget {
    static const String id = 'mainpagedriver';



  @override
  _MainPageDriverState createState() => _MainPageDriverState();
}

class _MainPageDriverState extends State<MainPageDriver> with SingleTickerProviderStateMixin{  
  
  TabController tabController;
  int selecetdIndex = 0;

  void onItemClicked(int index){
    setState(() {
      selecetdIndex = index;
      tabController.index = selecetdIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

 @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        
        children: <Widget>[
          HomeTab(),
          EarningsTab(),
          RatingsTab(),
          ProfileTab(),




        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label:'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label:'Ratings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label:'Account',
          ),
        ],
       currentIndex: selecetdIndex,
        unselectedItemColor: BrandColors.colorIcon,
        selectedItemColor: Colors.teal,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
      ),
      

    
    );
  }
}