import 'package:currency_converter/models/allcurrencies.dart';
import 'package:currency_converter/models/ratesmodel.dart';
import 'package:http/http.dart' as http;

Future<RatesModel> fetchrates() async {
  final response = await http.get(Uri.parse(
      'https://openexchangerates.org/api/latest.json?app_id=223f3dc301454e018b26104698a9afc4'));
  print(response.body);
  final result = ratesModelFromJson(response.body);

  return result;
}

Future<Map> fetchcurrencies() async {
  final response = await http
      .get(Uri.parse('https://openexchangerates.org/api/currencies.json'));
  final allCurrencies = allCurrenciesFromJson(response.body);

  return allCurrencies;
}

String convertousd(Map exchangeRates, String usd, String currency) {
  String output =
      ((exchangeRates[currency] * double.parse(usd).toStringAsFixed(2)))
          .toString();

  return output;
}

String convertany(Map exchangeRates, String amount, String currencybase,
    String currencyfinal) {
  String output = ((double.parse(amount) / exchangeRates[currencybase]) *
          exchangeRates[currencyfinal])
      .toStringAsFixed(2)
      .toString();
  return output;
}
