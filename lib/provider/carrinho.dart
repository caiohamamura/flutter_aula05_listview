import 'package:flutter/material.dart';

import '../model/produto.dart';

class Carrinho extends ChangeNotifier {
  final List<ItemCarrinho> itens = [];

  adicionaProduto(Produto produto) {
    int indice = itens.indexWhere((element) => element.produto == produto);
    if (indice > -1) {
      ItemCarrinho temp = itens[indice];
      var novoItem = ItemCarrinho(
        produto: produto,
        quantidade: temp.quantidade + 1,
      );
      itens.removeAt(indice);
      itens.insert(
        indice,
        novoItem,
      );
    } else {
      itens.add(
        ItemCarrinho(
          produto: produto,
          quantidade: 1,
        ),
      );
    }
  }
}

class ItemCarrinho {
  final Produto produto;
  final int quantidade;

  const ItemCarrinho({
    required this.produto,
    required this.quantidade,
  });

  double get precoItem => produto.preco * quantidade;
}
