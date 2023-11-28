import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
  final response = await http.post(
    url,
    body: {
      "origin": "501",
      "destination": "114",
      "weight": "1700",
      "courier": "jne",
    },
    headers: {
      "key": "6278f08a91c9fb78c982e3a273a20a4b",
      "content-type": "application/x-www-form-urlencoded",
    },
  );

  print(response.body);
}
