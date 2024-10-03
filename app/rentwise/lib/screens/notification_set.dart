import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/auth_methods.dart';
import 'package:rentwise/models/user.dart' as model;
import 'package:rentwise/resources/notification_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class NotificationSet extends StatefulWidget {
  const NotificationSet({super.key});

  @override
  State<NotificationSet> createState() => _NotificationSetState();
}

class _NotificationSetState extends State<NotificationSet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Future<List<model.User>>? _futureUser;
  model.User _selectedTenant = const model.User(uid: "", email: "", username: "All", phoneNumber: "", FCMToken: "", isManager: false);
  bool _isLoading = false;

  void closeNotificationSet() {
    Navigator.of(context).pop();
  }  

  void setStupidDropdown(model.User val) {
    _selectedTenant = val;
  }

  @override
  void initState() {
    super.initState();
    _futureUser = AuthMethods().getTenant();
    _futureUser?.then((value) {
      value.add(const model.User(uid: "", email: "", username: "All", phoneNumber: "", FCMToken: "", isManager: false));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void sendNotification() async {
    setState(() {
      _isLoading = true;
    });

    String res = await NotificationMethods().sendNotification(
      uid: _selectedTenant.uid,
      title: _titleController.text, 
      content: _contentController.text
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Notification successfully sent!', context);
      resetForm();
    }
  }

  void resetForm(){
    setState(() {
      _titleController.clear();
      _contentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    //final AuthMethods _authmethods = AuthMethods();

    return user == null ? 
    const Center(child: CircularProgressIndicator(),)
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
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          centerTitle: false,
          title: const Text(
            'Send Notification',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor
            )
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: closeNotificationSet,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 5, 32, 23),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),                
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Title',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    letterSpacing: -0.4,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ),
                              TextFieldInput(
                                  textEditingController: _titleController,
                                  hintText: '',
                                  textInputType: TextInputType.text
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Content',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    letterSpacing: -0.4,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ),
                              TextFieldInput(
                                  textEditingController: _contentController,
                                  hintText: '',
                                  textInputType: TextInputType.text
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Tenant',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    letterSpacing: -0.4,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFF334B48)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(13, 8, 8, 9),
                                  child: FutureBuilder<List<model.User>>(
                                    future: _futureUser, 
                                    builder: (context, AsyncSnapshot<List<model.User>> snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      //StatefulBuilder(builder: (context, setState) {
                                        return DropdownButton(
                                          dropdownColor: bgColor,
                                          hint: Text(
                                            'Select Tenant',
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              letterSpacing: -0.4,
                                              color: const Color(0xFF000000),
                                            ),
                                          ),
                                          value: _selectedTenant,
                                          items: snapshot.data!.map((user) {
                                            return DropdownMenuItem(
                                              value: user,
                                              child: Text(
                                                user.username,
                                                style: GoogleFonts.getFont(
                                                  'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  letterSpacing: -0.4,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            );
                                          }).toList(), 
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedTenant = value!;
                                            });
                                          }, 
                                        );                                        
                                      //});
                                    },
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: sendNotification,
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
                          : 
                          const Text('Send Notification'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}