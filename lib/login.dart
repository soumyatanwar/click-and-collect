import 'package:flutter/material.dart';
import 'package:Shrine/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Added editing controllers (101)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text('SHRINE', style: Theme.of(context).textTheme.headline),
              ],
            ),
            SizedBox(height: 120.0),
            // Added TextField widgets (101)
            // Removed filled: true values (103)
            // [Name]
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  //Removed filled: true,
                  labelText: 'Username',
                ),
              ),
            ),
            // spacer
            SizedBox(height: 12.0),
            // [Password]
            PrimaryColorOverride(
              color: kShrineBrown900,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  //Removed filled: true,
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            // Added button bar (101)
            ButtonBar(
              children: <Widget>[
                // Added buttons (101)
                FlatButton(
                  child: Text('CANCEL'),
                  // Added a beveled rectangular border to CANCEL (103)
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  onPressed: () {
                    // Clears the text fields (101)
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('NEXT'),
                  // Added an elevation to NEXT (103)
                  elevation: 8.0, //Default for raised buttons is 2.0
                  // Added a beveled rectangular border to NEXT (103)
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  onPressed: () {
                    // Shows the next page (101)
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Added PrimaryColorOverride (103)
class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
