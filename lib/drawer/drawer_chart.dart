import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomLogo extends StatefulWidget {
  const BottomLogo({Key? key}) : super(key: key);

  @override
  State<BottomLogo> createState() => _BottomLogoState();
}

class _BottomLogoState extends State<BottomLogo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            "Connect with Us",
            style: GoogleFonts.lato(color: Colors.grey),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "AutoConnect",
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
