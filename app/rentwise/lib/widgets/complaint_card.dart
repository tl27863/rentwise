import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentwise/utils/colors.dart';

class ComplaintCard extends StatelessWidget {
  final snap;
  const ComplaintCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.topCenter,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF334B48),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 10, 13, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${snap.name} - ${snap.roomName}',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
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
                        margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(1, 5, 0, 2),
                        child: Text(
                          snap.title,
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
                margin: const EdgeInsets.fromLTRB(3, 0, 3, 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
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
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                        child: Text(
                          DateFormat.yMMMd().format((snap.createdDate as Timestamp).toDate()),
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
                margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: snap.status == "Rejected" ?
                  rejectedColor
                  :
                  snap.status == "Completed" ?
                  acceptedColor
                  :
                  snap.status == "In Progress"?
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
                  padding: const EdgeInsets.fromLTRB(0, 9, 2.4, 9),
                  child: 
                  Text(
                    snap.status,
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: -0.4,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}