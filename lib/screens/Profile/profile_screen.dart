import 'package:flutter/material.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/screens/Profile/edit_form.dart';
import 'package:lms/screens/Profile/user_details.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/user_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel userModel = UserModel();

  bool _editClicked = false;

  void navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _editClicked
                  ? EditForm(
                      userModel: userModel,
                      onSaveClicked: () {
                        setState(() {
                          _editClicked = false;
                        });
                      },
                      onCancelClicked: () {
                        setState(() {
                          _editClicked = false;
                        });
                      },
                    )
                  : UserDetail(
                      onEditClicked: () {
                        setState(() {
                          _editClicked = true;
                        });
                      },
                      onSignOutClicked: () {
                        logout(context);
                      },
                      onGettingUserDetails: (user) {
                        setState(() {
                          userModel = user;
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    await context.read<AuthenticationService>().signOut();
    await UserPreferences.clearPreferences();
    Navigator.pushReplacementNamed(context, welcomeRoute);
  }
}
