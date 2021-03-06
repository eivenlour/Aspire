import 'package:flutter/material.dart';

import '../constants/common_constants.dart';
import 'format_text.dart';

class GlobalHeader extends StatelessWidget implements PreferredSizeWidget {
  final String actionText;
  final void Function() onActionTap;
  final bool isLight;

  GlobalHeader({
    Key key,
    this.actionText,
    this.onActionTap, 
    this.isLight = false
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var showAction = actionText != null && onActionTap != null;

    return AppBar(
      title: appBarTitle(), 
      actions: <Widget>[appBarAction(context, isVisible: showAction)],
      backgroundColor: Colors.transparent,
      centerTitle: false,
      elevation: 0.0
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  Widget appBarTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0), 
      child: FormatText(
        text: appName, 
        fontSize: globalHeaderFontSize,
        textColor: isLight ? Colors.white : Colors.black
      )
    );
}

  Widget appBarAction(BuildContext context, {bool isVisible}) {
    return isVisible
      ? Container( 
        padding: EdgeInsets.only(top: 18.5, right: 25.0),
        child: InkWell(
          onTap: onActionTap,
          child: FormatText(
            text: actionText,
            textColor: isLight 
              ? Colors.grey[50] 
              : Theme.of(context).accentColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500
          )
        )
      ) : SizedBox();
  }
}