import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/CustomTextField.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void handleLogin() async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if(success){
      print('login success');
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
        title: Text('Login'),
      ),
      body: Center(
        child: Card(
          child: Padding(padding: EdgeInsets.all(15),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  SizedBox(height: 10,),
                  isLoading ? CircularProgressIndicator() :
                  ElevatedButton(
                    onPressed: handleLogin,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                    ),
                    child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],),
            ),

          ),
        ),

      ),
    );
  }
}