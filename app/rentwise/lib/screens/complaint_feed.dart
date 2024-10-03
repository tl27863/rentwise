import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/complaint_methods.dart';
import 'package:rentwise/screens/complaint_detail.dart';
import 'package:rentwise/screens/complaint_set.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/models/complaint.dart' as model;
import 'package:rentwise/widgets/complaint_card.dart';

class ComplaintFeed extends StatefulWidget {
  const ComplaintFeed({super.key});

  @override
  State<ComplaintFeed> createState() => _ComplaintFeedState();
}

class _ComplaintFeedState extends State<ComplaintFeed> {
  Future<List<model.Complaint>>? _futureComplaint;
  int _inProgressCounter = 0; 
  int _completedCounter = 0; 
  int _awaitingReviewCounter = 0; 

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<List<model.Complaint>?> reload() async {
    _futureComplaint = ComplaintMethods().getComplaintFeed();
    _futureComplaint?.then((value) {
      _inProgressCounter = 0; 
      _completedCounter = 0; 
      _awaitingReviewCounter = 0; 
      for (var complaint in value) {
        if(complaint.status == "In Progress"){
          _inProgressCounter++;
        } else if(complaint.status == "Awaiting Review"){
          _awaitingReviewCounter++;
        } else if(complaint.status == "Completed"){
          _completedCounter++;
        }
      }
    });
    return _futureComplaint;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator(),)
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
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          centerTitle: false,
          title: Text('Complaint',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: -0.5,
              color: primaryColor,
            )
          ),
          actions: [
            user.isManager == false ?
            IconButton(
              onPressed: () {
                Navigator.of(context).
                  push(MaterialPageRoute(builder: (context) => const ComplaintSet()));
              }, 
              icon: const Icon(Icons.add,
              color: primaryColor)
            )
            :
            Container()
          ],
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Color(0xFF334B48),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color(0xFF388E85),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      ),
                      FutureBuilder<List<model.Complaint>?>(
                        future:  reload(),
                        builder: (context, AsyncSnapshot<List<model.Complaint>?> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.075, 
                              MediaQuery.of(context).size.height * 0.045, 
                              0, 
                              0
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Awaiting Review : $_awaitingReviewCounter',
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
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'In Progress : $_inProgressCounter',
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
                                  margin: const EdgeInsets.fromLTRB(0.3, 0, 0.3, 0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Completed : $_completedCounter',
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
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FutureBuilder<List<model.Complaint>>(
                  future:  _futureComplaint,
                  builder: (context, AsyncSnapshot<List<model.Complaint>> snapshot) {
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
                          MediaQuery.of(context).size.width * 0.01
                          :
                          0
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).
                              push(MaterialPageRoute(builder: (context) => ComplaintDetail(snap: snapshot.data?[index])));
                          },
                          child: ComplaintCard(
                            snap: snapshot.data?[index],
                          ),
                        ),
                      )
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}