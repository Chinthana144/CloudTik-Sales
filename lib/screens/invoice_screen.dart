import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/package_provider.dart';
import '../widgets/customer_select.dart';
import '../widgets/daily_total.dart';

class InvoiceScreen extends StatefulWidget{
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}//class

class _InvoiceScreenState extends State<InvoiceScreen>{
  bool _isLoading = false;
  List<dynamic> customers = [];
  Map<String, dynamic>? _selectedCustomer;
  List<dynamic> _selectedPackages = [];
  List<dynamic> todaySaleData = [];

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final packageProvider = Provider.of<PackageProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    todaySaleData = subscriptionProvider.subscriptions;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child:Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async{
                        FocusScope.of(context).unfocus();
                        setState(() => _isLoading = true);
                        try{
                          List<dynamic> result = await packageProvider.fetchCustomersWithPackages(context, _searchController.text);
                          setState(() {
                            customers = result;
                            // print("result: ${result.length}");
                            if(result.length > 0){
                              //show dialog box
                              showDialog(
                                context: context,
                                builder: (_)=> CustomerSelect(customers: customers),
                              ).then((result){
                                FocusScope.of(context).unfocus();
                                if(result != null){
                                 setState(() {
                                   _selectedCustomer = result['customer'];
                                   _selectedPackages = result['packages'];
                                   print('selected package ${_selectedPackages}');
                                 });
                                }
                              });
                            }
                            else{
                              showDialog(
                                  context: context, 
                                  builder: (_)=> AlertDialog(
                                    title: Text('No customer found'),
                                    content: Text('Please try again'),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    )],
                                  )
                              );
                            }
                          });
                        }//try
                        catch(e) {
                          print('no result, failed from catch');
                        }//catch
                      }
                    ),
                  ),
                ),

                //add daily sales
                DailyTotal(data: todaySaleData),

                //if has selected customer
                if(_selectedCustomer != null)
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                            _selectedCustomer!['fullname'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            _selectedCustomer!['username'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                if(_selectedCustomer == null)
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Please select a customer'),
                  ),
                ),

                //if has selected packages
                if(_selectedPackages.isNotEmpty)
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _selectedPackages.length,
                          itemBuilder: (context, index) {
                           final package = _selectedPackages[index];
                           return Card(
                             child: ListTile(
                               title: Text(
                                   package['name'],
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                               subtitle: Text(
                                   package['price'].toString() + ' AED',
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                 )
                               ),
                               trailing: ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.blue[700],
                                   foregroundColor: Colors.white,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                 ),
                                 onPressed: () async{
                                    final success = await subscriptionProvider.addSubscription(context, _selectedCustomer!['id'].toString(), package['id'].toString());
                                    if(success){
                                      showDialog(
                                          context: context,
                                          builder: (_)=>AlertDialog(
                                            title: Text('Subscription Added'),
                                            content: Text('Subscription added successfully'),
                                            actions: [
                                              TextButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                  //clear every thing
                                                  _selectedCustomer = null;
                                                  _selectedPackages = [];
                                                  _searchController.clear();
                                                  setState(() {
                                                    Provider.of<SubscriptionProvider>(context, listen: false).fetchSubscriptionsByUserDate(context, null);
                                                  });
                                                },
                                                child: Text('OK'),
                                              )],
                                          )
                                      );
                                    }
                                 },
                                 child: Text(
                                     '${package['duration'].toString()} Days',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                 ),
                               ),
                             ),
                           );
                          }
                        ),
                      ],
                    )
                  ),
                ),
              ],
        ),
        ),
      ),
    );
  }//build
}//class