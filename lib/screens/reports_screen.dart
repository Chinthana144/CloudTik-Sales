import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';

class ReportsScreen extends StatefulWidget{
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}//class

class _ReportsScreenState extends State<ReportsScreen>{
  bool _isLoading = false;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _data = [];
  final _dateController = TextEditingController();

  // Function to open date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider
          .of<SubscriptionProvider>(context, listen: false)
          .fetchSubscriptionsByUserDate(context, null);
    });
  }//init state

  @override
  Widget build(BuildContext context) {
    final subsProvider = Provider.of<SubscriptionProvider>(context);
    final double totalPrice = 0;
    _data = subsProvider.subscriptions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Sales Reports'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            Provider.of<SubscriptionProvider>(context, listen: false).fetchSubscriptionsByUserDate(context, _dateController.text);
                          });
                          },
                        icon: Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _pickDate(context),
                ),
              ),
            ),

            _data.isEmpty ? Text('no data found')
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('count = ${_data.length}'),
                Text('total = ${calculateTotal(_data)}'),
              ],
            ),
            Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final data = _data[index];
                    return Card(
                      child: ListTile(
                        title: Text(data['customer_name'].toString() + ' : ' + data['username'].toString()),
                        subtitle: Text(data['package_name'].toString()),
                        trailing: Text(
                            data['price'].toString() + ' AED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                        ),
                      ),
                    );
                  },
                ),
            ),

          ],
        ),
      ),
    );
  }

  double calculateTotal(List<dynamic> data){
    // Sum of price (converted from String to double)
    final totalPrice = data.fold<double>(
      0.0,
          (sum, item) => sum + double.tryParse(item['price'].toString())!,
    );

    return totalPrice;
  }
}//class