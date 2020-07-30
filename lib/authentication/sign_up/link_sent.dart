import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';

import '../../common/common.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';
import '../firebase_authentication.dart';
import '../login.dart';


class LinkSent extends StatefulWidget {
  final String emailAddress;

  LinkSent({Key key, @required this.emailAddress}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinkSent();
}

class _LinkSent extends State<LinkSent> {
  final GlobalKey<FormBuilderState> _disabledEmailAddressFormKey
    = GlobalKey<FormBuilderState>();

  bool isLoading;
  Store<AppState> store;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();

    isLoading = false;

    store = StoreProvider.of<AppState>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalHeader(
        actionText: signInAction,
        onActionTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => Login()
          )
        )
      ),
      body: Stack(
        children: <Widget>[
          buildLinkSentView(),
          buildCircularProgress(),
        ],
      )
    );
  }

  Widget buildCircularProgress() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator()
      );
    }
    return SizedBox();
  }

  Widget buildLinkSentView() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: screenHeight * 0.15,
          child: buildCenterAno()
        ),
        Positioned(
          top: screenHeight * 0.35,
          child: buildForm()
        ),
        buildReminderSection(),
        buildFooter()
      ]
    );
  }

  Widget buildForm() {
    return Container(
      width: screenWidth * 0.60,
      child: FormBuilder(
        key: _disabledEmailAddressFormKey,
        child: Column(
          children: <Widget>[
            buildEmailAddressField(),
          ]
        )
      )
    );
  }

  Widget buildCenterAno() {
    return Container(
      width: screenWidth,
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'images/diverse_ano.svg',
            height: screenHeight * 0.11,
          ),
          Container(
            height: 1.5,
            color: Colors.black
          )
        ]
      )
    );
  }

  Widget buildEmailAddressField() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FormBuilderTextField(
        enabled: false,
        readOnly: true,
        attribute: 'emailAddress',
        initialValue: widget.emailAddress,
        style: fieldTextStyle(color: Colors.grey),
        decoration: fieldDecoration(
          context,
          isFocused: false,
          isInvalid: false,
          hintText: emailHint,
          icon: Icons.mail_outline
        )
      )
    );
  }

  Widget buildReminderSection() {
    return Positioned(
      top: screenHeight * 0.50,
      child: Column(
        children: <Widget>[
          buildLinkSentDisabledButton(),
          buildLinkSentInfoText()
        ]
      )
    );
  }

  Widget buildLinkSentInfoText() {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: FormatText(
        text: linkSentInfoText,
        textColor: Theme.of(context).primaryColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
    );
  }

  Widget buildLinkSentDisabledButton() {
    return DisabledButton(
      text: linkSentDisabledButton
    );
  }

  Widget buildFooter() {
    return Positioned(
      bottom: screenHeight * 0.05,
      child: Row(
        children: <Widget>[
          buildFooterText(),
          buildFooterLink()
        ]
      )
      );
  }

  Widget buildFooterText() {
    return FormatText(
      text: linkSentFooterText,
      textColor: Theme.of(context).primaryColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    );
  }

  Widget buildFooterLink() {
    return InkWell(
      onTap: () => Auth().sendEmailVerification(),
      child: FormatText(
        text: linkSentFooterLink,
        textColor: Theme.of(context).accentColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
    );
  }
}