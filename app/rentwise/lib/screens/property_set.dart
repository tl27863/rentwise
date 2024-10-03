import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentwise/resources/property_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class PropertySet extends StatefulWidget {
  final snap;
  const PropertySet({super.key, this.snap});

  @override
  State<PropertySet> createState() => _PropertySetState();
}

class _PropertySetState extends State<PropertySet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  Uint8List? _image;
  bool _isEdit = false;
  bool _isLoading = false;

  void closePropertySet() {
    Navigator.of(context).pop();
  }  

  @override
  void initState() {
    super.initState();
    if(widget.snap != null){
      _emailController.text = widget.snap.email;
      _addressController.text = widget.snap.address;
      _nameController.text = widget.snap.name;
      _phoneNumberController.text = widget.snap.phoneNumber;
      _isEdit = true;
      //_image = (NetworkImage(widget.snap.photoURL) as Uint8List);
    } 
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void createProperty() async {
    setState(() {
      _isLoading = true;
    });
    
    // if(_image == null){
    //   final ByteData bytes = await rootBundle.load('assets/defaultUserIcon.jpg');
    //   _image = bytes.buffer.asUint8List();
    // }

    String res = await PropertyMethods().createProperty(
        email: _emailController.text,
        address: _addressController.text,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        file: _image!
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Property successfully created!', context);
      resetForm();
    }
  }

  void editProperty() async {
    setState(() {
      _isLoading = true;
    });
    
    String res = await PropertyMethods().updateProperty(
        pId: widget.snap.pId,
        uid: widget.snap.uid,
        email: _emailController.text,
        address: _addressController.text,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text,
        file: _image
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Property successfully edited!', context);
    }
  }

  void resetForm(){
    setState(() {
      _image = null;
      _emailController.clear();
      _addressController.clear();
      _nameController.clear();
      _phoneNumberController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Property',
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
            onPressed: closePropertySet,
          ),
        ), 
      ),
      body: SingleChildScrollView(
        child: SafeArea(
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
                Stack(
                  children: [
                    _isEdit ?
                      Container(
                        margin: const EdgeInsets.fromLTRB(
                          8, 
                          8, 
                          8, 
                          0
                        ),
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: _image != null 
                            ?
                            MemoryImage(_image!) 
                            :
                            NetworkImage(widget.snap.photoURL),
                            fit: BoxFit.cover,
                            alignment: FractionalOffset.topCenter
                          )
                        ),
                        child: Container()
                      )
                      :
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
                    textEditingController: _nameController,
                    hintText: 'Property Name',
                    textInputType: TextInputType.text),
                const SizedBox(height: 12),
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                TextFieldInput(
                    textEditingController: _phoneNumberController,
                    hintText: 'Phone Number',
                    isPassword: false,
                    textInputType: TextInputType.text),
                const SizedBox(height: 12),
                TextFieldInput(
                    textEditingController: _addressController,
                    hintText: 'Address',
                    isPassword: false,
                    textInputType: TextInputType.text),
                const SizedBox(height: 6),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _isEdit
                    ? editProperty
                    : createProperty,
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
                        : _isEdit
                        ? const Text('Confirm Edit')
                        : const Text('Create Property'),
                  ),
                ),
                //const SizedBox(height: 12),
                //Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
        ),
      )
    );
  }
}