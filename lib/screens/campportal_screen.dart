import 'package:flutter/material.dart';

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
                title: Text('camp id = ${camp['camp_id']}'),
                subtitle: Text('user id = ${camp['user_id']}'),
              );
            }
          ),
      ),
    );
  }
}