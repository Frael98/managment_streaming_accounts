import 'package:f_managment_stream_accounts/forms/subscripcion/subscription_form.dart';
import 'package:flutter/material.dart';

class SubscriptionListView extends StatefulWidget {
  const SubscriptionListView({super.key});

  @override
  State<SubscriptionListView> createState() => _SubscriptionListViewState();
}

class _SubscriptionListViewState extends State<SubscriptionListView> {
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
                  builder: (context) => const SubscriptionFormScreen(),
                ),
              );

        },
        child: const Icon(Icons.add),
      //body: ,
      ),
    );
  }
}
