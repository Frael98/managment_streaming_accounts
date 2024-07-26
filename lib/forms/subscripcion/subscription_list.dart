import 'dart:developer';

import 'package:f_managment_stream_accounts/controllers/mongo/subscription_controller_mongo.dart';
import 'package:f_managment_stream_accounts/forms/subscripcion/subscription_form.dart';
import 'package:f_managment_stream_accounts/models/subscription.dart';
import 'package:flutter/material.dart';

class SubscriptionListView extends StatefulWidget {
  const SubscriptionListView({super.key});

  @override
  State<SubscriptionListView> createState() => _SubscriptionListViewState();
}

class _SubscriptionListViewState extends State<SubscriptionListView> {
  List<Subscription>? _subscriptions;

  @override
  void initState() {
    initializeSubscriptions();
    super.initState();
  }

  Future initializeSubscriptions() async {
    try {
      List<Subscription>? tmp =
          await SubscriptionControllerMongo.getSubscriptionsList();
      setState(() {
        _subscriptions = tmp;
      });
      //log("Subscripciones cargadas ${tmp.length}");
    } catch (e) {
      log('Error consultando subscriptions $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscripciones'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubscriptionFormScreen(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: _subscriptions != null
          ? buildSubscriptionsList(context, _subscriptions!)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  /// Tile de Subscripcion
  Widget buildSubscriptionsList(
      BuildContext context, List<Subscription>? subscriptions) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: subscriptions!.length,
        itemBuilder: (_, index) {
          final subscription = subscriptions[index];

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SubscriptionFormScreen(idSubscription: subscription.uid,);
                  }));
                },
                splashColor: Colors.white.withOpacity(0.1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${subscription.codSubscription}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subscription.account!.email!,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(subscription.account!.platform!.namePlatform!),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
