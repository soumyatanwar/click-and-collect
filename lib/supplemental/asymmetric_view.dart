import 'package:flutter/material.dart';
import 'package:Shrine/model/product.dart';
import 'package:intl/intl.dart';
import 'package:Shrine/fab.dart';
import 'package:Shrine/product_view.dart';

class AsymmetricView extends StatelessWidget {
  final List<Product> products;

  AsymmetricView({Key key, this.products});

  List<Card> _buildGridCards(BuildContext context) {
    if (products == null || products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        // Adjust card heights (103)
        elevation: 0.0,
        child: Column(
          // Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductViewPage(product)));
              },
              child: AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.asset(
                  product.assetName,
                  package: product.assetPackage,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: [
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
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              product == null
                                  ? ''
                                  : formatter.format(product.price),
                              style: theme.textTheme.caption,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (products == null || products.isEmpty) {
      print("No matches found");
    }
    return Stack(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(context),
        ),
        buildFab(),
      ],
    );
  }
}
