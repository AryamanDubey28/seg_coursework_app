import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:seg_coursework_app/data/choice_boards_data.dart';
import 'package:seg_coursework_app/helpers/error_dialog_helper.dart';
import 'package:seg_coursework_app/helpers/mock_firebase_authentication.dart';
import 'package:seg_coursework_app/pages/admin/admin_choice_boards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg_coursework_app/pages/authenticate/wrapper.dart';
import 'package:seg_coursework_app/pages/authenticate/edit_account.dart';
import 'package:seg_coursework_app/pages/theme_page/theme_page.dart';
import 'package:seg_coursework_app/services/auth.dart';
import '../../helpers/error_dialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../visual_timetable/visual_timetable.dart';
import 'package:seg_coursework_app/pages/child_menu/customizable_column.dart';

/// The side-menu of the admin's UI
class AdminSideMenu extends StatelessWidget {
  final bool mock;

  const AdminSideMenu({Key? key, this.mock = false}) : super(key: key);

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

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          ListTile(
            key: const Key("choiceBoards"),
            leading: const Icon(
              Icons.photo_size_select_actual_outlined,
            ),
            title: const Text('Choice boards'),
            onTap: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              if (!mock) {
                return AdminChoiceBoards();
              } else {
                return AdminChoiceBoards(
                  mock: true,
                  testCategories: testCategories,
                  auth: MockFirebaseAuthentication(),
                  firestore: FakeFirebaseFirestore(),
                  storage: MockFirebaseStorage(),
                );
              }
            })),
          ),
          ListTile(
            key: const Key("visualTimetable"),
            leading: const Icon(
              Icons.event,
            ),
            title: const Text('Visual Timetable'),
            onTap: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              if (!mock) {
                return VisualTimeTable();
              } else {
                return VisualTimeTable(
                  isMock: mock,
                  auth: MockFirebaseAuthentication(),
                  firestore: FakeFirebaseFirestore(),
                  storage: MockFirebaseStorage(),
                );
              }
            })),
          ),
          ListTile(
              key: const Key("childMode"),
              leading: const Icon(
                Icons.child_care,
              ),
              title: const Text('Activate Child Mode'),
              onTap: () async {
                Auth authenticationHelper;

                if (!mock) {
                  authenticationHelper = Auth(
                      auth: FirebaseAuth.instance,
                      firestore: FirebaseFirestore.instance);
                } else {
                  //if mocking, authenticationHelper assigned to a mock auth
                  authenticationHelper = Auth(
                      auth: MockFirebaseAuth(),
                      firestore: FakeFirebaseFirestore());
                }
                bool check = await authenticationHelper.checkPinExists();
                if (mock) {
                  check = true;
                }

                if (check) {
                  //PIN exists
                  final String pin =
                      await authenticationHelper.getCurrentUserPIN();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CustomizableColumn(
                      mock: mock,
                      auth: authenticationHelper.auth,
                      firebaseFirestore: authenticationHelper.firestore,
                    ),
                  ));
                  final pref = await SharedPreferences.getInstance();
                  pref.setBool("isInChildMode",
                      true); //isInChildMode boolean set to true as we are entering
                } else {
                  var dialog = ErrorDialogHelper(context: context);
                  dialog.show_alert_dialog(
                      "Please first create a PIN in the 'Edit Account Details' section");
                }
              }),
          ListTile(
            key: const Key("appColours"),
            leading: const Icon(
              Icons.color_lens_outlined,
            ),
            title: const Text('Edit App Colours'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemePage(),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.black54,
          ),
          ListTile(
            key: const Key("accountDetails"),
            leading: const Icon(
              Icons.account_box_outlined,
            ),
            title: const Text('Edit Account Details'),
            onTap: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              if (!mock) {
                return EditAccountPage();
              } else {
                return EditAccountPage(
                  auth: MockFirebaseAuthentication(),
                );
              }
            })),
          ),
          ListTile(
            key: const Key("logout"),
            leading: const Icon(
              Icons.logout_outlined,
            ),
            title: const Text('Log out'),
            onTap: () async {
              FirebaseAuth.instance.signOut();
              final pref = await SharedPreferences.getInstance();
              Auth authenticationHelper;
              if (!mock) {
                authenticationHelper = Auth(
                    auth: FirebaseAuth.instance,
                    firestore: FirebaseFirestore.instance);
              } else {
                authenticationHelper = Auth(
                    auth: MockFirebaseAuth(),
                    firestore: FakeFirebaseFirestore());
              }
              final String pin = await authenticationHelper.getCurrentUserPIN();
              final isInChildMode = pref.getBool('isInChildMode') ?? false;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Wrapper(
                      isInChildMode: isInChildMode,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
