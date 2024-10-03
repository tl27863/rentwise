import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentwise/resources/complaint_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class ComplaintSet extends StatefulWidget {
  const ComplaintSet({super.key});

  @override
  State<ComplaintSet> createState() => _ComplaintSetState();
}

class _ComplaintSetState extends State<ComplaintSet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void closeComplaintSet() {
    Navigator.of(context).pop();
  }  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void createComplaint() async {
    setState(() {
      _isLoading = true;
    });
    
    // if(_image == null){
    //   final ByteData bytes = await rootBundle.load('assets/defaultUserIcon.jpg');
    //   _image = bytes.buffer.asUint8List();
    // }

    String res = await ComplaintMethods().createComplaint(
        title: _titleController.text,
        content: _contentController.text,
        file: _image!
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Complaint successfully sent!', context);
      resetForm();
    }
  }

  void resetForm(){
    setState(() {
      _image = null;
      _titleController.clear();
      _contentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Send Complaint',
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
            onPressed: closeComplaintSet,
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
              // const SizedBox(height: 32),
              Stack(
                children: [
                  _image != null
                  ? 
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    height: MediaQuery.of(context).size.height * 0.30,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter
                      )
                    ),
                    child: Container()
                  )   
                  : 
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    height: MediaQuery.of(context).size.height * 0.30,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage('https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png'),
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter
                      )
                    ),
                    child: Container()
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo,
                            color: secondaryColor),
                      ))
                ],
              ),
              const SizedBox(height: 32),
              TextFieldInput(
                  textEditingController: _titleController,
                  hintText: 'Title',
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _contentController,
                  hintText: 'Content',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              InkWell(
                onTap: createComplaint,
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
                      const Text('Send Complaint'),
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