import "package:currency_converter/components/anyToAny.dart";
import "package:currency_converter/components/usdtoany.dart";
import "package:currency_converter/functions/fletchrates.dart";
import "package:currency_converter/models/ratesmodel.dart";
import "package:flutter/material.dart";

class CurrencyConveter extends StatefulWidget {
  const CurrencyConveter({super.key});

  @override
  State<CurrencyConveter> createState() => _CurrencyConveterState();
}

class _CurrencyConveterState extends State<CurrencyConveter> {
  late Future<RatesModel> result;
  late Future<Map> allCurrencies;
  // late Future<Map> all
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    result = fetchrates();
    allCurrencies = fetchcurrencies();
  }

  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency exchange'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 55, 31, 31),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: FutureBuilder<RatesModel>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                      child: FutureBuilder<Map>(
                          future: allCurrencies,
                          builder: (context, currSnapshot) {
                            if (currSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                              children: [
                                UsdToAny(
                                    rates: snapshot.data!.rates,
                                    currencies: currSnapshot.data!),
                                const SizedBox(
                                  height: 60,
                                ),
                                AnyToAny(
                                    rates: snapshot.data!.rates,
                                    currencies: currSnapshot.data!),
                              ],
                            );
                          }));
                }),
          ),
        ),
      ),
    );
  }
}
