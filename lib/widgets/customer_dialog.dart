import 'package:cloudtik_sales/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../widgets/CustomNumberField.dart';

class CustomerDialog extends StatefulWidget{
  final Function(String name, String phone, String pwd) onSubmit;
  final String? title;
  final int? customer_id;
  final String? name;
  final String? phone;
  final String? pwd;

  const CustomerDialog({
    super.key,
    required this.onSubmit,
    this.title,
    this.customer_id,
    this.name,
    this.phone,
    this.pwd,
  });

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog>{
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _phoneController.text = widget.phone ?? '';
    _pwdController.text = widget.pwd ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'Add Account'),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: "Name",
                hint: "Enter your name",
                controller: _nameController,
              ),
              SizedBox(height: 10,),
              CustomNumberField(
                  label: "Phone No",
                  hint: "0512345678",
                  controller: _phoneController,
              ),
              SizedBox(height: 10,),
              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: _pwdController,
                obscureText: true,
              ),
              SizedBox(height: 10,),
            ]),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
            onPressed: (){
              if(_formKey.currentState!.validate()){
                widget.onSubmit(_nameController.text, _phoneController.text, _pwdController.text);
                Navigator.pop(context);
                _nameController.clear();
                _phoneController.clear();
                _pwdController.clear();
                Provider.of<CustomerProvider>(context, listen: false).fetchCustomers(context);
              }
            },
            child: Text(widget.name != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
