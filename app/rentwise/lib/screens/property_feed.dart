import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise/models/user.dart';
import 'package:rentwise/providers/user_provider.dart';
import 'package:rentwise/resources/property_methods.dart';
import 'package:rentwise/screens/property_set.dart';
import 'package:rentwise/screens/property_detail.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/models/property.dart' as model;
import 'package:rentwise/widgets/property_card.dart';

class PropertyFeed extends StatefulWidget {
  const PropertyFeed({super.key});

  @override
  State<PropertyFeed> createState() => _PropertyFeedState();
}

class _PropertyFeedState extends State<PropertyFeed> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final PropertyMethods _propertyMethods = PropertyMethods();
  
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
          title: Text('Property',
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
                  push(MaterialPageRoute(builder: (context) => const PropertySet()));
              }, 
              icon: const Icon(Icons.add,
                color: primaryColor)
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FutureBuilder<List<model.Property>>(
            future:  _propertyMethods.getPropertyFeed(),
            builder: (context, AsyncSnapshot<List<model.Property>> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(snapshot.error != null) {
                return const SizedBox();
              }
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
                        push(MaterialPageRoute(builder: (context) => PropertyDetail(snap: snapshot.data?[index])));
                    },
                    child: PropertyCard(
                      snap: snapshot.data?[index],
                    ),
                  ),
                )
              );
            },
          ),
        ),
      )
    );
  }
}