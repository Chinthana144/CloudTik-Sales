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
          child: Column(children: [
            Text('Select camp'),
            Expanded(
              child: ListView.builder(
                itemCount: userCamps.length,
                itemBuilder: (context, index) =>Card(

                  color: Colors.blue[900],
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: Text(
                          '${userCamps[index]['camp_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      ),
                      subtitle: Text(
                          '${userCamps[index]['camp_location']}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: IconButton(
                            onPressed: (){
                              sessionProvider.setSession(
                                  user: userCamps[index]['user_id'],
                                  camp: userCamps[index]['camp_id']
                              );
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen())
                              );
                            },
                            icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                        )
                      ),
                      onTap: (){
                        sessionProvider.setSession(
                            user: userCamps[index]['user_id'],
                            camp: userCamps[index]['camp_id']
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen())
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
          ],),


      ),
    );
  }
}