import 'package:intl/intl.dart';
import 'package:rentwise/models/property.dart';
import 'package:rentwise/models/user.dart' as model;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/auth_methods.dart';
import 'package:rentwise/resources/property_methods.dart';
import 'package:rentwise/resources/room_methods.dart';
import 'package:rentwise/screens/room_set.dart';
import 'package:rentwise/utils/colors.dart';

class RoomDetail extends StatefulWidget {
  final snap;
  const RoomDetail({super.key, required this.snap});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  Future<Room>? _futureRoom;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<Room?> reload() async {
    //print(widget.snap.rId);
    _futureRoom = RoomMethods().getRoom(rId: widget.snap.rId);
    _futureRoom?.then((value) {
      widget.snap.name = value.name;
      widget.snap.photoURL = value.photoURL;
      widget.snap.price = value.price;
      widget.snap.floor = value.floor;
      widget.snap.description = value.description;
      widget.snap.uid = value.uid;
    });
    return _futureRoom;
  }

  void closeRoomDetail() {
    Navigator.of(context).pop();
  }  

  @override
  Widget build(BuildContext context) {
    final cFormat = NumberFormat.currency(
      locale: 'id', 
      symbol: 'Rp. ',
      decimalDigits: 2
    );
    final User? user = Provider.of<UserProvider>(context).getUser;
    final AuthMethods _authmethods = AuthMethods();

    return user == null ? 
    const Center(child: CircularProgressIndicator())
    :
    Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight
        ),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: primaryColor
            ),
            onPressed: closeRoomDetail,
          ),
          title: Text('Room Details',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: -0.5,
              color: primaryColor,
            )
          ),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).
                  push(MaterialPageRoute(builder: (context) => RoomSet(snap: widget.snap, pId: widget.snap.pId)));
              },
              icon: const Icon(
                Icons.edit,
                color: primaryColor,
              )
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          reload;
          setState(() {
            
          });
        },
        child: FutureBuilder<Room?>(
          future: reload(), 
          builder: (context, AsyncSnapshot<Room?> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(snapshot.error != null) {
              return const SizedBox();
            }
            return Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.04, 
                0, 
                MediaQuery.of(context).size.width * 0.04, 
                MediaQuery.of(context).size.height * 0.04
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.topCenter,
                                  image: NetworkImage(
                                    widget.snap.photoURL,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.3,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 23),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF334B48),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(17.3, 8, 31.8, 22),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(3.7, 0, 0, 8),
                                        child: Text(
                                          widget.snap.name,
                                          style: GoogleFonts.getFont(
                                            'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                            letterSpacing: -0.5,
                                            color: const Color(0xFFFFFFFF),
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
                                                margin: const EdgeInsets.fromLTRB(0, 0, 4.8, 0),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/icons_8_vaccine_6432.png',
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
                                                  cFormat.format(int.parse(widget.snap.price)),
                                                  style: GoogleFonts.getFont(
                                                    'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: -0.3,
                                                    color: const Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(1.2, 0, 1.2, 4),
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
                                                        'assets/icons_8_location_961.png',
                                                      ),
                                                    ),
                                                  ),
                                                  child: const SizedBox(
                                                    width: 27.6,
                                                    height: 24,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(0, 2, 0, 3),
                                                child: Text(
                                                  widget.snap.floor,
                                                  style: GoogleFonts.getFont(
                                                    'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: -0.3,
                                                    color: const Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(3.5, 0, 3.5, 0),
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
                                                        'assets/icons_8_location_9631.png',
                                                      ),
                                                    ),
                                                  ),
                                                  child: const SizedBox(
                                                    width: 23,
                                                    height: 23,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                                                child: Text(
                                                  widget.snap.uid == "" ? 'Vacant' : 'Occupied',
                                                  style: GoogleFonts.getFont(
                                                    'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: -0.3,
                                                    color: const Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            widget.snap.uid == "" ?
                            const SizedBox()
                            :
                            FutureBuilder<model.User>(
                              future: _authmethods.getTenantDetails(uid: widget.snap.uid), 
                              builder: (context, AsyncSnapshot<model.User> snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if(snapshot.error != null){
                                  return const SizedBox();
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF334B48),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(17.3, 15, 0, 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(3.7, 0, 3.7, 8),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data!.username,
                                                style: GoogleFonts.getFont(
                                                  'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 24,
                                                  letterSpacing: -0.5,
                                                  color: const Color(0xFFFFFFFF),
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
                                                    margin: const EdgeInsets.fromLTRB(0, 0, 4.8, 0),
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                            'assets/icons8-email-30.png',
                                                          ),
                                                        ),
                                                      ),
                                                      child: const SizedBox(
                                                        width: 26,
                                                        height: 26,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 2),
                                                    child: Text(
                                                      snapshot.data!.email,
                                                      style: GoogleFonts.getFont(
                                                        'Inter',
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16,
                                                        letterSpacing: -0.3,
                                                        color: const Color(0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(1.2, 0, 1.2, 0),
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
                                                            'assets/icons8-phone-30.png',
                                                          ),
                                                        ),
                                                      ),
                                                      child: const SizedBox(
                                                        width: 27.6,
                                                        height: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.fromLTRB(0, 2, 0, 3),
                                                    child: Text(
                                                      snapshot.data!.phoneNumber,
                                                      style: GoogleFonts.getFont(
                                                        'Inter',
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16,
                                                        letterSpacing: -0.3,
                                                        color: const Color(0xFFFFFFFF),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );                            
                                }
                                //return const SizedBox();
                              }
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF334B48),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(21, 15, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Description',
                                          style: GoogleFonts.getFont(
                                            'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                            letterSpacing: -0.5,
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(1, 0, 1, 82),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          widget.snap.description,
                                          style: GoogleFonts.getFont(
                                            'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            letterSpacing: -0.3,
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            );
          }
        )
      )
    );
  }
}