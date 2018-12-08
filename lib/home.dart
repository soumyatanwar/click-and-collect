import 'package:flutter/material.dart';

import 'package:Shrine/model/data.dart';
import 'package:Shrine/model/product.dart';
import 'package:Shrine/supplemental/asymmetric_view.dart';

class HomePage extends StatelessWidget {
  final Category category;

  const HomePage({this.category: Category.all});

  @override
  Widget build(BuildContext context) {
    return AsymmetricView(products: ProductRepository.getProducts(category));
  }
}