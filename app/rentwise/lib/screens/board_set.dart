import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/board_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class BoardSet extends StatefulWidget {
  final snap;
  const BoardSet({super.key, this.snap});

  @override
  State<BoardSet> createState() => _BoardSetState();
}

class _BoardSetState extends State<BoardSet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  bool _isReply = false;

  void closeBoardSet() {
    Navigator.of(context).pop();
  }  

  @override
  void initState(){
    super.initState();
      if(widget.snap != null){
      _isReply = true;
    } 
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void sendBoard() async {
    setState(() {
      _isLoading = true;
    });

    String res = await BoardMethods().sendBoard(
      brId: _isReply ? widget.snap.bId : "",
      title: _titleController.text, 
      content: _contentController.text
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      _isReply ?
      showSnackBar('Comment successfully posted!', context)
      :
      showSnackBar('Board successfully posted!', context);
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
          backgroundColor: bgColor,
          centerTitle: false,
          title: Text(
            _isReply ?
            "Comment Board"
            :
            'Send Board',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor
            )
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: closeBoardSet,
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
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: sendBoard,
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
                          : _isReply ?
                          const Text('Post Comment')
                          :
                          const Text('Post Board'),
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