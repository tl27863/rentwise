import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BoardComment extends StatelessWidget {
  final snap;
  const BoardComment({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF334B48),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF334B48),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 15, 15.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${snap.name} Replied ${DateFormat.yMMMd().format((snap.createdDate as Timestamp).toDate())}',
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
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                  color: const Color(0xFF388E85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(13, 13, 33.2, 18.5),
                  child: 
                  Text(
                    snap.content,
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
            ],
          ),
        ),
      ),
    );
  }
}