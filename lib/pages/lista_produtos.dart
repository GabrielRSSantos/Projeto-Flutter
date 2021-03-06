import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:max_shoes_vendedor/controllers/user_controller.dart';
import 'package:max_shoes_vendedor/crud/add_produto.dart';
import 'package:max_shoes_vendedor/crud/edit_produto_page.dart';
import 'package:max_shoes_vendedor/models/produto_model.dart';
import 'package:provider/provider.dart';

class ListaProduto extends StatefulWidget {
  @override
  _ListaProdutoState createState() => _ListaProdutoState();
}

class _ListaProdutoState extends State<ListaProduto> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );
  dynamic dropdownValue = 'Opções';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            //filtra a coleção
            .collection('produtos')
            .where('ownerKey', isEqualTo: userController.user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final produtos = snapshot.data!.docs.map((map) {
            final data = map.data();
            return ProdutoModel.fromMap(data, map.id);
          }).toList();

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ListTile(
                title: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.settings),
                          iconSize: 20,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (texto) {
                            setState(() {
                              dropdownValue = texto!;
                            });
                            if (dropdownValue == 'Apagar') {
                              showAlertDialog3(context, produto);

                            } else if (dropdownValue == 'Editar') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProdutoPage(produto: produto),
                                  ));
                            }
                          },
                          items: <String>['Opções', 'Editar', 'Apagar']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            produto.imagem != null
                                ? Image.memory(produto.imagem!,
                                    width: 110, fit: BoxFit.cover)
                                : Container(
                                    child: Center(child: Text('No image')),
                                    width: 110,
                                    height: 110,
                                    color: Colors.grey,
                                  ),
                            produto.imagem2 != null
                                ? Image.memory(produto.imagem2!,
                                    width: 110, fit: BoxFit.cover)
                                : Container(
                                    child: Center(child: Text('No image')),
                                    width: 110,
                                    height: 110,
                                    color: Colors.grey,
                                  ),
                            produto.imagem3 != null
                                ? Image.memory(produto.imagem3!,
                                    width: 110, fit: BoxFit.cover)
                                : Container(
                                    child: Center(child: Text('No image')),
                                    width: 110,
                                    height: 110,
                                    color: Colors.grey,
                                  ),
                          ],
                        ),
                        Center(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text('Produto: ${produto.nome}'),
                                  SizedBox(height: 5),
                                  Text('Categoria: ${produto.categoria}'),
                                  SizedBox(height: 5),
                                  Text('Preço R\$:${produto.preco}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff89c2d9),
        child: Icon(Icons.add, color: Color(0xff343a40)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduto(),
            ),
          );
        },
      ),
    );
  }
}

showAlertDialog3(BuildContext context, ProdutoModel produto) {
  // configura os botões
  Widget lembrarButton = TextButton(
    child: Text('Apagar'),
    onPressed: () {
      FirebaseFirestore.instance
          .collection('produtos')
          .doc(produto.key)
          .delete();
      Navigator.pop(context);
    },
  );
  Widget cancelaButton = TextButton(
    child: Text("Cancelar"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // configura o  AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Aviso"),
    content: Text("Deseja mesmo apagar esse produto?"),
    actions: [
      lembrarButton,
      cancelaButton,
    ],
  );
  // exibe o dialogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
