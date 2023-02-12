import 'package:flutter/material.dart';
import 'package:seg_coursework_app/pages/admin_choice_boards.dart';

/// The side-menu of the admin's UI
class AdminSideMenu extends StatelessWidget {
  const AdminSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        key: const Key("adminSideMenu"),
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
              title: const Text('Choice boards'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AdminChoiceBoards(),
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