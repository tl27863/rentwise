import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rentwise/models/board.dart' as model;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/board_methods.dart';
import 'package:rentwise/screens/board_set.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/widgets/board_comment.dart';

class BoardDetail extends StatefulWidget {
  final snap;
  const BoardDetail({super.key, required this.snap});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  void closeBoardDetail() {
    Navigator.of(context).pop();
  }  

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final BoardMethods _boardMethods = BoardMethods();

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
            onPressed: closeBoardDetail,
          ),
          backgroundColor: bgColor,
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).
                  push(MaterialPageRoute(builder: (context) => BoardSet(snap: widget.snap)));
              },
              icon: const Icon(
                Icons.add,
                color: primaryColor,
              )
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        displacement: 100,
        onRefresh: () async {
          setState(() {
            
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF334B48),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 15, 15, 15.5),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF334B48),
                          ),
                          margin: const EdgeInsets.fromLTRB(4.7, 0, 4.7, 27),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.snap.title,
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
                          decoration: BoxDecoration(
                            color: const Color(0xFF388E85),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
                            child: 
                            Text(
                              widget.snap.content,
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
                        //const SizedBox(height: 100),
                        FutureBuilder<List<model.Board>>(
                          future: _boardMethods.getBoardDetail(bId: widget.snap.bId), 
                          builder: (context, AsyncSnapshot<List<model.Board>> snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if(snapshot.error != null){
                              return const SizedBox();
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                //padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => 
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width > 600 ?
                                    MediaQuery.of(context).size.width * 0.19
                                    :
                                    0
                                  ),
                                  child: BoardComment(
                                      snap: snapshot.data?[index],
                                  ),
                                ),
                              );                              
                            }
                          }
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 5,
                    top: 27,
                    child: SizedBox(
                      height: 19,
                      child: Text(
                        'By ${widget.snap.name}',
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
                  Positioned(
                    left: 104,
                    top: 27,
                    child: SizedBox(
                      height: 19,
                      child: Text(
                        DateFormat.yMMMd().format((widget.snap.createdDate as Timestamp).toDate()),
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
        )
      )
    );
  }
}