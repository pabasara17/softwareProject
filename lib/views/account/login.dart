import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:jwel_smart/logic/authentication.dart';
import 'package:jwel_smart/views/helpers/alert.dart';
import 'package:jwel_smart/views/helpers/app_navigator.dart';
import 'package:jwel_smart/views/splash.dart';

import 'register.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        centerTitle: true,
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FormBuilder(
        key: _fbKey,
        child: Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: Theme.of(context).accentColor),
          child: ListView(
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.contain,
              ),
              _buildTitle("Email"),
              _email,
              _buildTitle("Password"),
              _password,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.indigo,
                      textColor: Colors.white,
                      child: Text("Login"),
                      onPressed: () => _handleFormSubmit(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text("Create Account"),
                      onPressed: processing
                          ? null
                          : () {
                              AppNavigator.push(context, (_) => RegisterView());
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _email => Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilderTextField(
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ],
          keyboardType: TextInputType.emailAddress,
          attribute: "email",
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "email@website.com",
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget get _password => Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilderTextField(
          validators: [
            FormBuilderValidators.required(),
          ],
          obscureText: true,
          attribute: "password",
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, bottom: 0.0, top: 20.0),
      child: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _handleFormSubmit() async {
    _fbKey.currentState.save();
    if (_fbKey.currentState.validate()) {
      setState(() {
        processing = true;
      });
      bool isLoggedIn = await Authentication.login(
          _fbKey.currentState.value['email'],
          _fbKey.currentState.value['password'], (e) {
        if (mounted) {
          Alert.showAlertBox(context, e.toString());
        }
      });

      if (mounted) {
        setState(() {
          processing = false;
        });
        if (isLoggedIn) {
          AppNavigator.pushAsFirst(context, (_) => SplashScreen());
        }
      }
    }
  }
}