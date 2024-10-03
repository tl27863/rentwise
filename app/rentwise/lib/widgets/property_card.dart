import 'package:flutter/material.dart';
import 'package:rentwise/utils/colors.dart';

class PropertyCard extends StatelessWidget {
  final snap;
  const PropertyCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(style: BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              8, 
              8, 
              8, 
              0
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
              image: DecorationImage(
                image: NetworkImage(snap.photoURL),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter
              )
            ),
            child: Container()
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(style: BorderStyle.none),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(snap.name,
                    style: const TextStyle(
                      color: bgColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 24
                    )
                  ),
                ),
                Text(
                  snap.address,
                  style: const TextStyle(
                    color: bgColor,
                    fontSize: 18
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );  
  }
}