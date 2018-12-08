import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:scoped_model/scoped_model.dart';
import 'package:Shrine/model/data.dart';
import 'colors.dart';
//import 'expanding_bottom_sheet.dart';
import 'model/app_state_model.dart';
import 'model/product.dart';

double _salesTaxRate = 0.18;
const _leftColumnWidth = 60.0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {

  // All the available products.
  List<Product> _availableProducts;

// The currently selected category of products.
  Category _selectedCategory = Category.all;

// The IDs and quantities of products currently in the cart.
  Map<int, int> _productsInCart = {};

  Map<int, int> get productsInCart => Map.from(_productsInCart);

// Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);

  Category get selectedCategory => _selectedCategory;

// Totaled prices of the items in the cart.
  double get subtotalCost => _productsInCart.keys
      .map((id) => _availableProducts[id].price * _productsInCart[id])
      .fold(0.0, (sum, e) => sum + e);

// Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

// Total cost to order everything in the cart.
  double get totalCost => subtotalCost + tax;

// Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) return List<Product>();
    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }

// Adds a product to the cart.
  void addProductToCart(int productId) {
    setState(() {
      if (!_productsInCart.containsKey(productId)) {
        _productsInCart[productId] = 1;
      } else {
        _productsInCart[productId]++;
      }
    });
  }

// Removes an item from the cart.
  void removeItemFromCart(int productId) {
    setState(() {
      if (_productsInCart.containsKey(productId)) {
        if (_productsInCart[productId] == 1) {
          _productsInCart.remove(productId);
        } else {
          _productsInCart[productId]--;
        }
      }
    });

  }

// Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  Product getProductByName(String name) {
    return _availableProducts.firstWhere((p) => p.name == name);
  }

// Removes everything from the cart.
  void clearCart() {

    setState(() {
      _productsInCart.clear();
    });
  }

// Loads the list of available products from the repo.
  void loadProducts() {
    setState(() {
      _availableProducts = ProductRepository.getProducts(Category.all);
    });
  }

  void setCategory(Category newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

  List<Widget> _createShoppingCartRows() {
    return productsInCart.keys
        .map(
          (id) => ShoppingCartRow(
        product: getProductById(id),
        quantity: productsInCart[id],
        onPressed: () {
          removeItemFromCart(id);
        },
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: kShrinePink50,
      body: SafeArea(
        child: Container(
          child:
          //ScopedModelDescendant<AppStateModel>(
            //builder: (context, child, model) {
              //return
                Stack(
                children: [
                  ListView(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: _leftColumnWidth,
                            child: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () {} //ExpandingBottomSheet.of(context).close()
                            ),
                          ),
                          Text(
                            'CART',
                            style: localTheme.textTheme.subhead
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16.0),
                          Text('$totalCartQuantity ITEMS'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: _createShoppingCartRows(),
                      ),
                      ShoppingCartSummary(totalCost,subtotalCost,tax),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: RaisedButton(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      color: kShrinePink100,
                      splashColor: kShrineBrown600,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('CLEAR CART'),
                      ),
                      onPressed: () {
                        clearCart();
                       // ExpandingBottomSheet.of(context).close();
                      },
                    ),
                  ),
                ],
    ),
          ),
        ),
    );
  }
}

class ShoppingCartSummary extends StatelessWidget {
//  ShoppingCartSummary({this.model});
final double tax, totalCost, subtotalCost;
  ShoppingCartSummary(this.totalCost,this.subtotalCost,this.tax);
//  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
    Theme.of(context).textTheme.body1.copyWith(color: kShrineBrown600);
    final largeAmountStyle = Theme.of(context).textTheme.display1;
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 2, locale: Localizations.localeOf(context).toString());

    return Row(
      children: [
        SizedBox(width: _leftColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text('TOTAL'),
                    ),
                    Text(
                      formatter.format(totalCost),
                      style: largeAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Subtotal:'),
                    ),
                    Text(
                      formatter.format(subtotalCost),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
//                    const Expanded(
//                      child: Text('Shipping:'),
//                    ),
//                    Text(
//                      formatter.format(model.shippingCost),
//                      style: smallAmountStyle,
//                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Tax:'),
                    ),
                    Text(
                      formatter.format(tax),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatelessWidget {
  ShoppingCartRow(
      {@required this.product, @required this.quantity, this.onPressed});

  final Product product;
  final int quantity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        key: ValueKey(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _leftColumnWidth,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onPressed,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        product.assetName,
                        package: product.assetPackage,
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Quantity: $quantity'),
                                ),
                                Text('x ${formatter.format(product.price)}'),
                              ],
                            ),
                            Text(
                              product.name,
                              style: localTheme.textTheme.subhead
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: kShrineBrown900,
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}