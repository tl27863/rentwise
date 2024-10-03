import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/board_methods.dart';
import 'package:rentwise/screens/board_detail.dart';
import 'package:rentwise/screens/board_set.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/models/board.dart' as model;
import 'package:rentwise/widgets/board_card.dart';

class BoardFeed extends StatefulWidget {
  const BoardFeed({super.key});

  @override
  State<BoardFeed> createState() => _BoardFeedState();
}

class _BoardFeedState extends State<BoardFeed> {
  final BoardMethods _boardMethods = BoardMethods();
  Future<List<model.Board>>? _futureBoard;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<List<model.Board>?> reload() async {
    _futureBoard = _boardMethods.getBoardFeed();
    _futureBoard?.then((value) {
      
    });
    return _futureBoard;
  }  

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator(),)
    :
    Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MediaQuery.of(context).size.width > 600 ?
      null
      :
      PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          centerTitle: false,
          title: Text('Board',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: -0.5,
              color: primaryColor,
            )
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).
                  push(MaterialPageRoute(builder: (context) => const BoardSet()));
              }, 
              icon: const Icon(
                Icons.add,
                color: primaryColor
              )
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        displacement: 100,
        onRefresh: () async {
          reload;
          setState(() {
            
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.04, 
            0, 
            MediaQuery.of(context).size.width * 0.04, 
            MediaQuery.of(context).size.height * 0.04
          ),
          child: FutureBuilder<List<model.Board>?>(
            future:  reload(),
            builder: (context, AsyncSnapshot<List<model.Board>?> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(snapshot.error != null){
                return const SizedBox();
              } else {
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                          push(MaterialPageRoute(builder: (context) => BoardDetail(snap: snapshot.data?[index])));
                      },
                      child: 
                      BoardCard(
                        snap: snapshot.data?[index],
                      ),
                    ),
                  )
                );
              }
            },
          ),
        ),
      )
    );
  }
}