import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/complaint.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/complaint_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';

class ComplaintDetail extends StatefulWidget {
  final snap;
  const ComplaintDetail({super.key, this.snap});

  @override
  State<ComplaintDetail> createState() => _ComplaintDetailState();
}

class _ComplaintDetailState extends State<ComplaintDetail> {
  Future<Complaint>? _futureComplaint;
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<Complaint?> reload() async {
    _futureComplaint = ComplaintMethods().getComplaint(cId: widget.snap.cId);
    _futureComplaint?.then((value) {
    });
    return _futureComplaint;
  }

  void closeComplaintDetail() {
    Navigator.of(context).pop();
  }  

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void processComplaint(String status) async {
    setState(() {
      _isLoading = true;
    });
    
    String res = await ComplaintMethods().processComplaint(
        cId: widget.snap.cId,
        status: status,
        file: _image
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar('Complaint $status', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator())
    :
    Scaffold(
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
          title: const Text(
            'Complaint Detail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor
            )
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: closeComplaintDetail,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          reload;
          setState(() {
            
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder<Complaint?>(
            future: reload(), 
            builder: (context, AsyncSnapshot<Complaint?> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(snapshot.error != null) {
                return const SizedBox();
              }
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 21),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(12.7, 10, 15, 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(6.9, 0, 6.9, 6),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '${snapshot.data?.name} - ${snapshot.data?.roomName}',
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24,
                                              letterSpacing: -0.5,
                                              color: bgColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(0, 0, 4.6, 0),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/icons8-loudspeaker-30.png',
                                                      ),
                                                    ),
                                                  ),
                                                  child: const SizedBox(
                                                    width: 29.9,
                                                    height: 26,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                                                child: Text(
                                                  snapshot.data!.title,
                                                  style: GoogleFonts.getFont(
                                                    'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: -0.3,
                                                    color: bgColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(3.5, 0, 3.5, 10),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(0, 0, 8.1, 0),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/icons_8_clock_482.png',
                                                      ),
                                                    ),
                                                  ),
                                                  child: const SizedBox(
                                                    width: 23,
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                                                child: Text(
                                                  DateFormat.yMMMd().format((snapshot.data?.createdDate as Timestamp).toDate()),
                                                  style: GoogleFonts.getFont(
                                                    'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: -0.3,
                                                    color: bgColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                          ),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * 0.2,
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            margin: const EdgeInsets.fromLTRB(13, 0, 13, 13),
                                            padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: const Color(0xFF388E85),
                                            ),
                                            child: 
                                            Text(
                                              snapshot.data!.content,
                                              maxLines: 4,
                                              style: GoogleFonts.getFont(
                                                'Inter',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: -0.3,
                                                color: const Color(0xFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(3.5, 0, 0, 0),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: snapshot.data?.status == "Rejected" ?
                                          rejectedColor
                                          :
                                          snapshot.data?.status == "Completed" ?
                                          acceptedColor
                                          :
                                          snapshot.data?.status == "In Progress"?
                                          inProgressColor
                                          :
                                          validateColor
                                          ,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                              blurRadius: 2.5,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(2.5, 9, 0, 9),
                                          child: 
                                          Text(
                                            snapshot.data!.status,
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                              letterSpacing: -0.4,
                                              color: bgColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.37,
                                padding: const EdgeInsets.fromLTRB(20, 6, 15, 16),
                                child: 
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(
                                        snapshot.data!.cPhotoURL,
                                      ),
                                    ),
                                  ),
                                  child: const SizedBox(
                                    width: 342,
                                    height: 291,
                                  ),
                                ),
                              ),
                            ),
                            snapshot.data?.pPhotoURL != "" ?
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.37,
                                padding: const EdgeInsets.fromLTRB(20, 6, 15, 16),
                                child: 
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(
                                        snapshot.data!.pPhotoURL,
                                      ),
                                    ),
                                  ),
                                  child: const SizedBox(
                                    width: 342,
                                    height: 291,
                                  ),
                                ),
                              ),
                            )
                            :
                            Container()
                          ],
                        ),
                      ),
                    ),
                    user.isManager ?
                      snapshot.data?.status != "In Progress" ?
                      Container()
                      :
                      Stack(
                        children: [
                          //_image != null
                          //? 
                          Container(
                            margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                            height: MediaQuery.of(context).size.height * 0.30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor,
                                width: 2
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                image: _image != null 
                                ?
                                MemoryImage(_image!) 
                                :
                                const NetworkImage('https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png'),
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.topCenter
                              )
                            ),
                            child: Container()
                          ),   
                          //: 
                          // Container(
                          //   margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                          //   height: MediaQuery.of(context).size.height * 0.30,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: primaryColor,
                          //       width: 2
                          //     ),
                          //     borderRadius: const BorderRadius.all(Radius.circular(20)),
                          //     image: const DecorationImage(
                          //       image: NetworkImage('https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png'),
                          //       fit: BoxFit.cover,
                          //       alignment: FractionalOffset.topCenter
                          //     )
                          //   ),
                          //   child: Container()
                          // ),        
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
                      )
                    :
                    Container(),
                    user.isManager ?
                      snapshot.data?.status == "Awaiting Review" ?
                      InkWell(
                        onTap: () {
                          processComplaint("In Progress");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(24, 24, 25, 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: acceptedColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(0, 2),
                                blurRadius: 2.5,
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 19, 9.5, 19),
                            width: MediaQuery.of(context).size.width,
                            child: _isLoading ?
                            const Center(child: CircularProgressIndicator(
                                  color: bgColor,
                                ))
                            :
                            Text(
                              'PROCESS COMPLAINT',
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                letterSpacing: -0.4,
                                color: bgColor,
                              ),
                            ),
                          ),
                        )
                      )
                      :
                      Container()
                    :
                    Container(),
                    user.isManager ?
                      snapshot.data?.status == "In Progress" ?
                      InkWell(
                        onTap: () {
                          processComplaint("Completed");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(24, 0, 25, 0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: inProgressColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(0, 2),
                                blurRadius: 2.5,
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 19, 1, 19),
                            child: _isLoading ?
                            const Center(child: CircularProgressIndicator(
                                  color: bgColor,
                                ))
                            :
                            Text(
                              'SUBMIT PROOF',
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                letterSpacing: -0.4,
                                color: bgColor,
                              ),
                            ),
                          ),
                        )
                      )
                      :
                      Container()
                    :
                    Container(),
                    user.isManager ?
                      snapshot.data?.status == "Awaiting Review" ?
                      InkWell(
                        onTap: () {
                          processComplaint("Rejected");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(24, 0, 25, 0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: rejectedColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                offset: Offset(0, 2),
                                blurRadius: 2.5,
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 19, 1, 19),
                            child: _isLoading ?
                            const Center(child: CircularProgressIndicator(
                                  color: bgColor,
                                ))
                            :
                            Text(
                              'REJECT COMPLAINT',
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                letterSpacing: -0.4,
                                color: bgColor,
                              ),
                            ),
                          ),
                        )
                      )
                      :
                      Container()
                    :
                    Container(),
                  ],
                ),
              );
            }
          )
        )
      )
    );
  }
}