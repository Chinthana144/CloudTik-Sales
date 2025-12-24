import 'package:cloudtik_sales/screens/campportal_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/CustomTextField.dart';
import '../providers/auth_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/loginButton.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void handleLogin() async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    String username = _emailController.text;
    String password = _passwordController.text;

    if (_rememberMe) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', true);
      await prefs.setString('username', username);
      await prefs.setString('password', password);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if(success){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CampPortal(
            user: authProvider.user!,
            userCamps: authProvider.userCamps,
            )
          ),
      );

      _emailController.clear();
      _passwordController.clear();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('CloudTik Sales'),
      ),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Card(
              child: Padding(padding: EdgeInsets.all(15),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/com_logo_3.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20,),
                      CustomTextField(
                        label: 'Email',
                        hint: 'enter your email',
                        obscureText: false,
                        controller: _emailController,
                      ),
                      SizedBox(height: 10,),
                      CustomTextField(
                        label: 'Password',
                        hint: 'enter your password',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      // SizedBox(height: 10,),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text("Remember Me"),
                        ],
                      ),
                      SizedBox(height: 10,),
                      isLoading ? CircularProgressIndicator() :
                      LoginButton(onPressed: handleLogin),
                    ],),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}