import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/auth_methods.dart';
import 'package:rentwise/screens/login_screen.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  Future<User>? _currentUser;
  bool _isLoading = false;

  void closeUserDetail() {
    Navigator.of(context).pop();
  }  

  @override
  void initState() {
    super.initState();
    _currentUser = AuthMethods().getUserDetails();
    _currentUser?.then((value) {
      _nameController.text = value.username;
      _emailController.text = value.email;
      _phoneNumberController.text = value.phoneNumber;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
  }

  void updateUser() async {
    setState(() {
      _isLoading = true;
    });
    
    String res = await AuthMethods().updateUser(
        username: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Data successfully updated!', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator())
    :
    Scaffold(
      extendBodyBehindAppBar: false,
      appBar: MediaQuery.of(context).size.width > 600 ?
      null
      :
      PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight
        ),
        child: AppBar(
          title: const Text(
            'User Detail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor
            )
          ),
          backgroundColor: bgColor,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: closeUserDetail,
          ),
        ), 
      ),
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600 ?
          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3)
          :
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              TextFieldInput(
                  textEditingController: _nameController,
                  hintText: 'Full Name',
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Email',
                  isEnabled: false,
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _phoneNumberController,
                  hintText: 'Phone Number',
                  isPassword: false,
                  textInputType: TextInputType.text),
              const SizedBox(height: 6),
              const SizedBox(height: 12),
              InkWell(
                onTap: updateUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: secondaryColor
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(
                        color: bgColor,
                      ))
                      :
                      const Text('Confirm Update')
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  AuthMethods().signOut();
                  Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: rejectedColor
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(
                        color: bgColor,
                      ))
                      :
                      const Text('Logout')
                ),
              ),
              //const SizedBox(height: 12),
              //Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}