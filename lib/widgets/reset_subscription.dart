import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/status_dialog.dart';

class ResetSubscription extends StatelessWidget{
  final String subscriptionId;
  final Map<String, dynamic> sub;

  const ResetSubscription({
    Key? key,
    required this.subscriptionId,
    required this.sub
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    return AlertDialog(
      title: Text("Reset  ${sub['subscription']['username']}"),
      content:
          Container(
            height: 180,
            child: Column(
              children: [
                Text(
                    '${sub['subscription']['customer_name']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () async{
                    final success = await subscriptionProvider.resetSubscription(context, sub['subscription']['id'].toString(), sub['subscription']['customer_id'].toString());

                    if(success){
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => const StatusDialog(
                            success: true,
                            message: 'Code reset successfully!',
                          ),
                        );
                    }
                    else{
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => const StatusDialog(
                          success: false,
                          message: 'Code reset failed. Please try again.',
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // 👈 background color
                    foregroundColor: Colors.white, // 👈 text (and ripple) color
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 👈 rounded corners
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                TextButton(
                    onPressed: ()=> Navigator.pop(context),
                    child: Text('Close'),
                )
              ],
            ),
          ),

    );
  }
}