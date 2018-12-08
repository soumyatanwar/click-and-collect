import 'package:flutter/material.dart';
import 'package:Shrine/model/product.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Shrine/model/app_state_model.dart';
import 'package:Shrine/colors.dart';
import 'package:Shrine/supplemental/cut_corners_border.dart';

class CounterModel extends Model {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if(count>0)
    _count--;
    notifyListeners();
  }
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // First, create a `ScopedModel` widget. This will provide
    // the `model` to the children that request it.
    return new ScopedModel<CounterModel>(
        model: new CounterModel(),
        child: new Column(children: [
          // Create a ScopedModelDescendant. This widget will get the
          // CounterModel from the nearest ScopedModel<CounterModel>.
          // It will hand that model to our builder method, and rebuild
          // any time the CounterModel changes (i.e. after we
          // `notifyListeners` in the Model).
          new ScopedModelDescendant<CounterModel>(
              builder: (context, child, model) => Row(
                    children: <Widget>[
                      FloatingActionButton(
                          heroTag: 'Decrement',
                          child: new Icon(Icons.remove),
                          onPressed: () {
                            model.decrement();
                          }),
                      SizedBox(width: 40.0),
                      new Text('${model.count}',
                          style: Theme.of(context).textTheme.body2),
                      SizedBox(width: 40.0),
                      FloatingActionButton(
                          heroTag: 'Increment',
                          child: new Icon(Icons.add),
                          onPressed: () {
                            model.increment();
                          }),
                    ],
                  )),
          SizedBox(height: 40.0),
        ]));
  }
}

class AddToCart extends StatelessWidget{
  int pid;
  AddToCart(this.pid);
  @override
  Widget build(BuildContext context){
    return new ScopedModel<AppStateModel>(
        model: new AppStateModel(),
      child: Column(
        children: <Widget>[
          new ScopedModelDescendant(builder: (context, child, model) => RaisedButton(
            onPressed: model.addProductToCart(pid),
          ))
        ],
      ),
        );
  }
}

class ProductViewPage extends StatelessWidget {
  final Product product;
  ProductViewPage(this.product);
  Card _buildProductView(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return Card(
        margin: EdgeInsets.all(16.0),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(90.0, 0.0, 20.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      // Align labels to the start(changed to add ADD button) and center (103)
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //Change innermost Column (103)
                      children: <Widget>[
                        //  Handled overflowing labels (103)
                        Text(
                          product == null ? '' : product.name,
                          style: theme.textTheme.button,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.3,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          product == null
                              ? ''
                              : formatter.format(product.price),
                          style: theme.textTheme.caption,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.3,
                        ),

                        Divider(),
                        Column(
                          children: <Widget>[
                            CounterApp(),
                            RaisedButton(
                              shape: BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.0))),
                              child: Text("Add to Cart"),
                              onPressed: () {
                                  AddToCart(product.id);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
        ),
        body: Stack(
          children: <Widget>[
          _buildProductView(context)
          ]
        ),
      ),
      theme: _kShrineTheme,
    );
  }
}

final ThemeData _kShrineTheme = _buildShrineTheme();

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kShrineBrown900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    primaryIconTheme: base.iconTheme.copyWith(color: kShrineBrown900),
    inputDecorationTheme: InputDecorationTheme(
      border: CutCornersBorder(),
    ),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    body2: base.body2.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: kShrineBrown900,
    bodyColor: kShrineBrown900,
  );
}