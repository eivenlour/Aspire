import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';

import '../../actions/actions.dart';
import '../../common/common.dart';
import '../../constants/constants.dart';
import '../../icons/aspire_icons.dart';
import '../../models/models.dart';
import '../../navigation/app_controller.dart';
import '../../services/services.dart';
import '../authentication.dart';
import '../sign_up/funnel.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  final GlobalKey<FormBuilderState> _loginFormKey
    = GlobalKey<FormBuilderState>();
  final FocusNode emailAddressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  String emailAddress, password;
  bool isEmailAddressFocused, isPasswordFocused;
  bool isEmailAddressInvalid, isPasswordInvalid;
  bool isLoading;
  Store<AppState> store;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();

    isLoading = false;
    isEmailAddressInvalid = false;
    isPasswordInvalid = false;
    isEmailAddressFocused = false;
    isPasswordFocused = false;
  
    emailAddressFocusListener();
    passwordFocusListener();

    store = StoreProvider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    emailAddressFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalHeader(
        actionText: signUpAction,
        onActionTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (context) => SignUpFunnel()
          )
        )
      ),
      body: Stack(
        children: <Widget>[
          buildLoginView(),
          buildCircularProgress(),
        ],
      )
    );
  }

  void emailAddressFocusListener() {
    emailAddressFocus.addListener(() {
      setState(() { isEmailAddressFocused = emailAddressFocus.hasFocus; });
    });
  }

  void passwordFocusListener() {
    passwordFocus.addListener(() {
      setState(() { isPasswordFocused = passwordFocus.hasFocus; });
    });
  }

  void validateAndSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (_loginFormKey.currentState.saveAndValidate()) {
      try {
        await login();
        setState(() {
          isLoading = false;
          isEmailAddressInvalid = false;
          isPasswordInvalid = false;
        });
      } on Exception catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
          _loginFormKey.currentState.reset();
        });
      }
    } else {
        setState(() {
          isLoading = false;
          isEmailAddressInvalid = true;
          isPasswordInvalid = true;
        });
    }
  }

  Future<void> login() async {
    var userId = await Auth().signIn(emailAddress, password);
    var userData = await getUser(userId);
    if (userData == null) {
      await addUser(userId, emailAddress);
      userData = await getUser(userId);
    }
    store.dispatch(ConvertToUserState(userData));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AppController()
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

  Widget buildLoginView() {
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
        Positioned(
          bottom: screenHeight * 0.05,
          child: FooterLinks()
        )
      ]
    );
  }

  Widget buildForm() {
    return Container(
      width: screenWidth * 0.60,
      child: FormBuilder(
        key: _loginFormKey,
        child: Column(
          children: <Widget>[
            buildEmailAddressField(),
            buildPasswordField(),
            buildForgotPasswordLink(),
            buildLoginButton()
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
            height: 100,
            width: 100,
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
    print(isEmailAddressInvalid);
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FormBuilderTextField(
        attribute: 'emailAddress',
        focusNode: emailAddressFocus,
        style: fieldTextStyle(color: Theme.of(context).primaryColor),
        decoration: loginFieldDecoration(
          context,
          isFocused: isEmailAddressFocused,
          isInvalid: isEmailAddressInvalid,
          hintText: emailHint,
          icon: Icons.mail_outline
        ),
        validators: [
          FormBuilderValidators.required(),
          FormBuilderValidators.email(),
          FormBuilderValidators.maxLength(100),
        ],
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => emailAddress = (value as String).trim(),
      )
    );
  }

  Widget buildPasswordField() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FormBuilderTextField(
        attribute: 'password',
        focusNode: passwordFocus,
        obscureText: true,
        maxLines: 1,
        style: fieldTextStyle(color: Theme.of(context).primaryColor),
        decoration: loginFieldDecoration(
          context,
          isFocused: isPasswordFocused,
          isInvalid: isPasswordInvalid,
          hintText: passwordHint,
          icon: AspireIcons.lock
        ),
        validators: [
          FormBuilderValidators.required(),
          FormBuilderValidators.maxLength(100),
        ],
        keyboardType: TextInputType.text,
        onSaved: (value) => password = (value as String).trim(),
      )
    );
  }

  Widget buildLoginButton() {
    return Container(
      padding: EdgeInsets.only(
        top: screenHeight * 0.10
      ),
      child: PrimaryButton(
        isLight: true,
        text: loginButton,
        onPressed: validateAndSubmit,
      )
    );
  }

  Widget buildForgotPasswordLink() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () => print('Forgot Password.'),
        child: FormatText(
          text: forgotPassword,
          textColor: Theme.of(context).accentColor,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        )
      )
    );
  }
}
