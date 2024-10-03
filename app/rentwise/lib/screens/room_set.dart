import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/auth_methods.dart';
import 'package:rentwise/models/user.dart' as model;
import 'package:rentwise/resources/room_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class RoomSet extends StatefulWidget {
  final snap;
  final String pId;
  const RoomSet({super.key, this.snap, required this.pId});

  @override
  State<RoomSet> createState() => _RoomSetState();
}

class _RoomSetState extends State<RoomSet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _image;
  Future<List<model.User>>? _futureUser;
  model.User _selectedTenant = const model.User(uid: "", email: "", username: "Vacant", phoneNumber: "", FCMToken: "", isManager: false);
  bool _isEdit = false;
  bool _isLoading = false;

  void closeRoomSet() {
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
      value.add(const model.User(uid: "", email: "", username: "Vacant", phoneNumber: "", FCMToken: "", isManager: false));
      for (var user in value) {
        if(user.uid == widget.snap.uid){
          _selectedTenant = user;
        }
      }
    });
    if(widget.snap != null){
      _nameController.text = widget.snap.name;
      _priceController.text = widget.snap.price;
      _floorController.text = widget.snap.floor;
      _descriptionController.text = widget.snap.description;
      _isEdit = true;
    } 
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _floorController.dispose();
    _descriptionController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void createRoom() async {
    setState(() {
      _isLoading = true;
    });
    
    // if(_image == null){
    //   final ByteData bytes = await rootBundle.load('assets/defaultUserIcon.jpg');
    //   _image = bytes.buffer.asUint8List();
    // }

    String res = await RoomMethods().createRoom(
      pId: widget.pId, 
      uid: _selectedTenant.uid, 
      name: _nameController.text, 
      price: _priceController.text, 
      floor: _floorController.text, 
      description: _descriptionController.text, 
      file: _image!
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Room successfully created!', context);
      resetForm();
    }
  }

  void editRoom() async {
    setState(() {
      _isLoading = true;
    });
    print(_selectedTenant.uid);

    String res = await RoomMethods().updateRoom(
      rId: widget.snap.rId,
      pId: widget.pId, 
      uid: _selectedTenant.uid, 
      name: _nameController.text, 
      price: _priceController.text, 
      floor: _floorController.text, 
      description: _descriptionController.text, 
      file: _image
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Room successfully edited!', context);
    }
  }

  void resetForm(){
    setState(() {
      _image = null;
      _nameController.clear();
      _priceController.clear();
      _floorController.clear();
      _descriptionController.clear();
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
          backgroundColor: bgColor,
          centerTitle: false,
          title: Text(
            _isEdit ?
            'Edit Room'
            :
            'Add Room',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor
            )
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: closeRoomSet,
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
                  Stack(
                    children: [
                      _isEdit ?
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            image: _image != null 
                            ?
                            MemoryImage(_image!) 
                            :
                            NetworkImage(widget.snap.photoURL)
                            ,
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
                          )
                      )
                    ],
                  ), 
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
                                  'Room Name',
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
                                  textEditingController: _nameController,
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
                                  'Rent Price',
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
                                  textEditingController: _priceController,
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
                                  'Floor',
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
                                  textEditingController: _floorController,
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
                                            'Select Renter',
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
                                                  color: const Color(0xFF000000),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Description',
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
                                  textEditingController: _descriptionController,
                                  hintText: '',
                                  textInputType: TextInputType.text
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _isEdit
                      ? editRoom
                      : createRoom,
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
                          : const Text('Create Room'),
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