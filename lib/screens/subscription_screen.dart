// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/qrcode_dialog.dart';
import '../widgets/view_subscription.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<dynamic> subscriptions = [];

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionProvider>(context, listen: false).fetchSubscriptionsByUserDate(context, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final subscriptions = subscriptionProvider.subscriptions;

    return Scaffold(
      body: Column(
        children: [
          // Text('Subscription Screen'),
          Container(
            padding: EdgeInsets.all(8),
            child:TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: (){
                    subscriptionProvider.searchSubscriptionByUser(context, _searchController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          SizedBox(height: 8,),
          Expanded(
            child: Scrollbar(
              child: subscriptions.isEmpty ?
              const Center(
                  child: Column(children: [
                    Text('No subscriptions found...'),
                    SizedBox(height: 8,),
                    CircularProgressIndicator(),
                  ]),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final subscription = subscriptions[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${subscription['username']} : ${subscription['price']} AED',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        '${subscription['customer_name']} : ${subscription['expiry_datetime'] ?? 'N/A'} '
                      ),
                      trailing: SizedBox(
                        width: 50,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final subscriptionId = subscription['id'].toString(); // Make sure it's a String if required
                                final data = await subscriptionProvider.getSubscriptionById(context, subscriptionId);

                                FocusScope.of(context).unfocus();
                                showDialog(
                                  context: context,
                                  builder: (context) => ViewSubscription(
                                    subscriptionId: subscriptionId,
                                    sub: data,
                                  ),
                                );
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                            ),

                          ]),
                      ),
                    ),
                  );
                }
              )
            ),
          ),
        ],
      ),
    );
  }
}