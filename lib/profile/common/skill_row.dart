import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';

class SkillRow extends StatelessWidget {
  final Skill skill;
  
  SkillRow({Key key, @required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildSkillText(
            skill.name,
            isSkill: true
          ),
          buildSkillText(
            skill.level,
            isSkill: false
          )
        ]
      )
    );
  }

  Widget buildSkillText(String text, {bool isSkill}) {
    return Text(
      text,
      textAlign: TextAlign.left,
      softWrap: true,
      style: GoogleFonts.muli(
        textStyle: TextStyle(
          color: isSkill ? Colors.black : Colors.black54,
          letterSpacing: .5,
          height: 1.2,
          fontSize: 13.0,
          fontWeight: isSkill ? FontWeight.w700 : FontWeight.w500
        ),
      )
    );
  }
}
