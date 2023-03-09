import 'package:flutter/material.dart';
import 'package:listview/provider/carrinho.dart';
import 'package:provider/provider.dart';

import 'model/produto.dart';
import 'data/produtos.dart';

void main() {
  runApp(const ProviderContainer());
}

class ProviderContainer extends StatelessWidget {
  const ProviderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Carrinho(),
        ),
      ],
      builder: (context, child) => Aplicativo(),
    );
  }
}

class Aplicativo extends StatelessWidget {
  const Aplicativo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            secondary: Colors.deepOrange,
          ),
          iconTheme: const IconThemeData(
            color: Colors.deepOrange,
            size: 20,
          )),
      home: MyHomePage(title: 'Pagina'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pag = 0;
  final controle = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pag,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
        ],
        onTap: (value) {
          pag = value;
          controle.animateToPage(value,
              duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        },
      ),
      body: PageView(
        controller: controle,
        children: [
          PaginaProdutos(),
          PaginaCarrinho(),
        ],
        onPageChanged: (value) {
          pag = value;
          setState(() {});
        },
      ),
    );
  }
}

class PaginaCarrinho extends StatelessWidget {
  const PaginaCarrinho({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...context.watch<Carrinho>().itens.map(
              (e) => ListTile(
                title: Text(e.produto.nome),
                trailing: Text('${e.quantidade}x'),
              ),
            )
      ],
    );
  }
}

class PaginaProdutos extends StatelessWidget {
  const PaginaProdutos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: produtos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          Produto produto = produtos[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              child: Image.network(
                produto.imageUrl,
                fit: BoxFit.cover,
              ),
              footer: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                ),
                child: GridTileBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Theme.of(context).iconTheme.color,
                      size: Theme.of(context).iconTheme.size,
                    ),
                    onPressed: () {},
                  ),
                  title: Text(
                    produtos[index].nome,
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).iconTheme.color,
                      size: Theme.of(context).iconTheme.size,
                    ),
                    onPressed: () {
                      context.read<Carrinho>().adicionaProduto(produto);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
