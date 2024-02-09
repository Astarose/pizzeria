import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pizzeria/models/pizza.dart';

class PizzeriaService {
  // URI de base pour l'appel
  // Ici, l'adresse IP 10.0.2.2 représente le localhost
  static final String uri = 'http://192.168.8.1/api/';

  Future<List<Pizza>> fetchPizzas() async {
    List<Pizza> list = [];

    try {
      // Appel http bloquant
      final response = await http
          .get(Uri.parse('${uri}pizzas'));

      if (response.statusCode == 200) {
        // var json = jsonDecode(response.body);
        // --> problèmes avec les accents
        // Décodage des accents : utf8.decode
        // Décodage JSON : jsonDecode
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        for (final value in json) {
          // Création de l'objet pizza avec le JSON :
          // Pizza.fromJson(json);
          // Puis ajout dans la liste
          list.add(Pizza.fromJson(value));
        }
      } else {
        throw Exception('Impossible de récupérer les pizzas');
      }
    } catch (e) {
      throw e;
    }

    return list;
  }

}
