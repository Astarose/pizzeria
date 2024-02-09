import 'package:flutter/material.dart';
import 'package:pizzeria/models/cart.dart';

class Panier extends StatefulWidget {
  final Cart _cart;

  const Panier(this._cart, {Key? key}) : super(key: key);

  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  double calculateTotal() {
    double total = 0.0;
    for (var item in widget._cart.items) {
      total += item.pizza.prix * item.quantity;
    }
    return total;
  }

  double calculateTVA(double total) {
    double tva = total * 0.20;
    return double.parse(tva.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    double totalHT = calculateTotal();
    double tva = calculateTVA(totalHT);
    double totalTTC = totalHT + tva;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon panier'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget._cart.totalItems(),
              itemBuilder: (context, index) {
                return _buildCartItem(widget._cart.getCartItem(index));
              },
            ),
          ),
          _buildTotalSection(totalHT, tva, totalTTC),
          SizedBox(height: 8.0),
          _buildValidateButton(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(item.pizza.image, width: 100),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.pizza.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.pizza.prix.toStringAsFixed(2)} €', style: TextStyle(color: Colors.blueGrey)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () => _changeQuantity(item, false), icon: Icon(Icons.remove)),
                          Text('${item.quantity}'),
                          IconButton(onPressed: () => _changeQuantity(item, true), icon: Icon(Icons.add)),
                        ],
                      ),
                    ],
                  ),
                  Text('Sous-Total: ${(item.pizza.prix * item.quantity).toStringAsFixed(2)} €',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTotalSection(double totalHT, double tva, double totalTTC) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
        },
        children: [
          TableRow(children: [
            Text(''),
            Text('TOTAL HT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey), textAlign: TextAlign.left),
            Text('${totalHT.toStringAsFixed(2)} €', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
          ]),
          TableRow(children: [
            Text(''),
            Text('TVA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey), textAlign: TextAlign.left),
            Text('${tva.toStringAsFixed(2)} €', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
          ]),
          TableRow(children: [
            Text(''),
            Text('TOTAL TTC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent), textAlign: TextAlign.left),
            Text('${totalTTC.toStringAsFixed(2)} €', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          ]),
        ],
      ),
    );
  }



  Widget _buildValidateButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0),
          elevation: 0,
          minimumSize: Size(double.infinity, 50),
        ),
          onPressed: () {

          },
          child: Text('VALIDER LE PANIER', style: TextStyle(fontSize: 16)),
        ),
    );
  }

  void _changeQuantity(CartItem item, bool increase) {
    setState(() {
      if (increase) {
        item.quantity++;
      } else {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          widget._cart.removeProduct(item.pizza);
        }
      }
    });
  }

}
