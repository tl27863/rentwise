import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/dashboard.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/dashboard_methods.dart';
import 'package:rentwise/screens/user_detail.dart';
import 'package:rentwise/utils/colors.dart';

class DashboardTenant extends StatefulWidget {
  const DashboardTenant({super.key});

  @override
  State<DashboardTenant> createState() => _DashboardTenantState();
}

class _DashboardTenantState extends State<DashboardTenant> {
  @override
  Widget build(BuildContext context) {
    final cFormat = NumberFormat.currency(
      locale: 'id', 
      symbol: 'Rp. ',
      decimalDigits: 2);
    final User? user = Provider.of<UserProvider>(context).getUser;
    final DashboardMethods _dashboardMethods = DashboardMethods();
  
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
          title: Text('Hello, ${user.username}',
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
                  push(MaterialPageRoute(builder: (context) => const UserDetail()));
              }, 
              icon: const Icon(Icons.account_circle,
                color: primaryColor,
                size: 32)
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: FutureBuilder<TDashboardData>(
              future:  _dashboardMethods.getTDashboard(),
              builder: (context, AsyncSnapshot<TDashboardData> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(21, 13, 0, 54),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snapshot.data!.roomName,
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22,
                                        letterSpacing: -0.4,
                                        color: bgColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(1, 0, 1, 6),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      cFormat.format(int.parse(snapshot.data!.roomPrice)),
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        letterSpacing: -0.3,
                                        color: bgColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snapshot.data!.roomFloor,
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        letterSpacing: -0.3,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(21, 18, 0, 45),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Financial',
                                          style: GoogleFonts.getFont(
                                            'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22,
                                            letterSpacing: -0.4,
                                            color: bgColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          cFormat.format(int.parse(snapshot.data!.pPrice)),
                                          style: GoogleFonts.getFont(
                                            'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            letterSpacing: -0.3,
                                            color: bgColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data!.pStatus,
                                          style: GoogleFonts.getFont(
                                            'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            letterSpacing: -0.3,
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
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(21, 13, 0, 50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Complaint',
                                        style: GoogleFonts.getFont(
                                          'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                          letterSpacing: -0.4,
                                          color: bgColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(1, 0, 1, 9),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        snapshot.data!.cComplaintName,
                                        style: GoogleFonts.getFont(
                                          'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          letterSpacing: -0.3,
                                          color: bgColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        snapshot.data!.cStatus,
                                        style: GoogleFonts.getFont(
                                          'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          letterSpacing: -0.3,
                                          color: bgColor,
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
                    ],
                  ),
                );
              },
            ),
          ),
        )
      )
    );
  }
}

