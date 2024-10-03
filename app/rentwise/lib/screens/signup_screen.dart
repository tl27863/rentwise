import 'package:flutter/material.dart';
import 'package:rentwise/resources/auth_methods.dart';
import 'package:rentwise/responsive/mobileScreen.dart';
import 'package:rentwise/responsive/responsive_layout.dart';
import 'package:rentwise/screens/login_screen.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

enum RoleSelector { manager, tenant}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  RoleSelector? _role = RoleSelector.manager;
  bool _isManager = true;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
  }

  // void selectImage() async {
  //   Uint8List img = await pickImage(ImageSource.gallery);
  //   setState(() {
  //     _image = img;
  //   });
  // }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    
    // if(_image == null){
    //   final ByteData bytes = await rootBundle.load('assets/defaultUserIcon.jpg');
    //   _image = bytes.buffer.asUint8List();
    // }

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        phoneNumber: _phoneNumberController.text,
        isManager: _isManager
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout()
          )
        )
      );
    }
  }

  void navigateTologIn() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Flexible(flex: 2, child: Container()),
              const Padding(
                padding: EdgeInsets.fromLTRB(0,0,15,0),
                child: Text('Register',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 42,
                  ),
                )
              ),
              const SizedBox(height: 16),
              // Stack(
              //   children: [
              //     _image != null
              //         ? CircleAvatar(
              //             radius: 64,
              //             backgroundImage: MemoryImage(_image!),
              //           )
              //         : const CircleAvatar(
              //             radius: 64,
              //             backgroundImage: NetworkImage(
              //                 'https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png'),
              //           ),
              //     Positioned(
              //         bottom: 0,
              //         right: 0,
              //         child: IconButton(
              //           onPressed: selectImage,
              //           icon: const Icon(Icons.add_a_photo,
              //               color: secondaryColor),
              //         ))
              //   ],
              // ),
              const SizedBox(height: 16),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Full Name',
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _phoneNumberController,
                  hintText: 'Phone Number',
                  isPassword: false,
                  textInputType: TextInputType.text),
              const SizedBox(height: 6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: ListTile(
                      title: const Text('Manager', 
                        style: TextStyle(color: tabIcon)),
                      leading: Radio<RoleSelector>(
                        activeColor: primaryColor,
                        value: RoleSelector.manager,
                        groupValue: _role, 
                        onChanged: (RoleSelector? value) { 
                          setState(() {
                            _role = value;
                            _isManager = true;
                          });
                          //print(value.toString());
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: ListTile(
                      title: const Text('Tenant', 
                        style: TextStyle(color: tabIcon)),
                      leading: Radio<RoleSelector>(
                        activeColor: primaryColor,
                        value: RoleSelector.tenant,
                        groupValue: _role, 
                        onChanged: (RoleSelector? value) { 
                          setState(() {
                            _role = value;
                            _isManager = false;
                          });
                          //print(value.toString());
                        },
                      ),
                    ),
                  )
                ]
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: secondaryColor),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(
                        color: bgColor,
                      ))
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Already registered? ',
                      style:  TextStyle(color: primaryColor)),
                  ),
                  GestureDetector(
                    onTap: navigateTologIn,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text('Log in.',
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor))),
                  )
                ],
              ),
              Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}