import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'explore_card.dart';

class explore extends StatefulWidget {
  const explore({Key? key}) : super(key: key);

  @override
  _exploreState createState() => _exploreState();
}

class _exploreState extends State<explore> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<bool> clicked_flags = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    List<String> arr = [
      'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
      'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
      'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
      'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
      'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
      'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
      'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
      'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
      'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
      'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
      'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
    ];
    return Scaffold(
      endDrawer: Drawer(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Choose tags"),
          leading: IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ListView(
                shrinkWrap: true,
                children: List.generate(
                  10,
                  (index) {
                    return Align(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            clicked_flags[index] = !clicked_flags[index];
                          });
                        },
                        child: Text("Tag #1"),
                        style: TextButton.styleFrom(
                            primary: (clicked_flags[index])
                                ? Colors.black
                                : Colors.white,
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.width * 0.1,
                            ),
                            shape: const StadiumBorder(),
                            backgroundColor: (clicked_flags[index])
                                ? Colors.deepOrange
                                : Colors.grey),
                      ),
                    );
                  },
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextButton(
              onPressed: () {},
              child: Text("Confirm"),
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.width * 0.1,
                  ),
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.deepOrange),
            )
          ],
        )),
      )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explore', textAlign: TextAlign.center),
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    print("hi");
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.filter_list))),
          SizedBox(width: 20)
        ],
      ),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Center(
                child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(10, (index) {
                      return explore_card(url: arr[index]);
                    }),
                  ),
                ),
              ))),
    );
  }
}
