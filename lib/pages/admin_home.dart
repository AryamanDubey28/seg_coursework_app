import 'package:flutter/material.dart';

// This widget is the root of the admin interface
class AdminInterface extends StatelessWidget {
  const AdminInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Home',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AdminHome(),
    );
  }
}

// The home page of the admin interface
class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: const NavigationDrawer(),
      );
}

// The side-menu of the admin's UI (should be moved to another file)
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        )),
      );

  // The header of the side-menu
  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  // The items of the side-menu
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_size_select_actual_outlined),
              title: const Text('Card Boards'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AdminHome(),
              )),
            ),
            ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Visual Timetable'),
                onTap: () {}),
            ListTile(
              leading: const Icon(Icons.child_care),
              title: const Text('Activate Child Mode'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: const Text('Edit App Colours'),
              onTap: () {},
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(Icons.account_box_outlined),
              title: const Text('Edit Account Details'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Log out'),
              onTap: () {},
            ),
          ],
        ),
      );
}
