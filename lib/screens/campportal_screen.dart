import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloudtik_sales/screens/home_screen.dart';

class CampPortal extends StatefulWidget{

  final Map<String, dynamic> user;
  final List<dynamic> userCamps;

   const CampPortal(
      {
        super.key,
        required this.user,
        required this.userCamps
      }
      );
  @override
  State<CampPortal> createState() => _CampPortalState();
}

class _CampPortalState extends State<CampPortal>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    List<dynamic> userCamps = widget.userCamps;
    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camp Portal'),
      ),
      body: Scrollbar(
          child: ListView.builder(
            itemCount: userCamps.length,
            itemBuilder: (context, index) {
              final camp = userCamps[index];
              return ListTile(
                title: Text('${camp['camp_name']}'),
                subtitle: Text('${camp['camp_location']}'),
                onTap: () {
                  sessionProvider.setSession(
                      user: camp['user_id'],
                      camp: camp['camp_id']
                  );

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              );
            }
          ),
      ),
    );
  }
}