import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/property.dart' as model;
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/property_methods.dart';
import 'package:rentwise/screens/room.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/widgets/room_card.dart';

class PropertyTenant extends StatefulWidget {
  const PropertyTenant({super.key});

  @override
  State<PropertyTenant> createState() => _PropertyTenantState();
}

class _PropertyTenantState extends State<PropertyTenant> {
  Future<List<model.Room>>? _futureRoom;
  Future<model.Property>? _futureProperty;
  int _roomCounter = 0; 

  @override
  void initState() {
    super.initState();
    _futureProperty = PropertyMethods().getPropertyTenant();
    _futureProperty?.then((value) {
      _futureRoom = PropertyMethods().getPropertyDetailsTenant(pId: value.pId);
      _futureRoom?.then((value) {
        _roomCounter = value.length;
      });      
    });
  }

  void closeExpandedDetail() {
    Navigator.of(context).pop();
  }  

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator())
    :
    Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Property',
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
        ),
      ),
      body: FutureBuilder<model.Property>(
        future: _futureProperty, 
        builder: (context, AsyncSnapshot<model.Property> snapshot) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.09,
                  // ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF334B48),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                              image: NetworkImage(
                                snapshot.data!.photoURL,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF334B48),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(17.3, 8, 0, 22),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(3.5, 0, 3.5, 8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data!.name,
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
                                              margin: const EdgeInsets.fromLTRB(0, 0, 4.6, 0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                      'assets/icons_8_vaccine_64311.png',
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
                                              child: FutureBuilder<List<model.Room>>(
                                                future:  _futureRoom,
                                                builder: (context, AsyncSnapshot<List<model.Room>> snapshot) {
                                                  if(snapshot.connectionState == ConnectionState.waiting){
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  return Text(
                                                    '${_roomCounter.toString()} Kamar',
                                                    style: GoogleFonts.getFont(
                                                      'Inter',
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 16,
                                                      letterSpacing: -0.3,
                                                      color: const Color(0xFFFFFFFF),
                                                    ),
                                                  );
                                                },
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
                                                snapshot.data!.address,
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
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                            ],
                          ),
                        ),
                        FutureBuilder<List<model.Room>>(
                          future:  _futureRoom,
                          builder: (context, AsyncSnapshot<List<model.Room>> snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(0,15,0,10),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => 
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width > 600 ?
                                  MediaQuery.of(context).size.width * 0.19
                                  :
                                  0
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).
                                      push(MaterialPageRoute(builder: (context) => RoomDetail(snap: snapshot.data?[index])));
                                  },
                                  child: RoomCard(
                                    snap: snapshot.data?[index],
                                  ),
                                ),
                              )
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            )
          );
        },
      )

    );
  }
}