import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RoomCard extends StatelessWidget {
  final snap;
  const RoomCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    final cFormat = NumberFormat.currency(
      locale: 'id', 
      symbol: 'Rp. ',
      decimalDigits: 2
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF334B48),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(17.3, 15, 31.8, 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(3.7, 0, 0, 8),
              child: Text(
                snap.name,
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
                        cFormat.format(int.parse(snap.price)),
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
                        snap.floor,
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
                        snap.uid == "" ? 'Vacant' : 'Occupied',
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
      )
    );
  }
}