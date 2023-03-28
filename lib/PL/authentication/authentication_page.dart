import 'package:finalmps/PL/authentication/register/google_sign_up.dart';
import 'package:finalmps/PL/authentication/register/register.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../start_point/splash_screen.dart';
import '../home/home_page/home_page.dart';
import '../utilites/helper/helper.dart';
import '../utilites/strings.dart';
import '../utilites/text_style/text_styles.dart';
import '../utilites/themes/app_colors/dark_colors.dart';
import '../utilites/themes/app_colors/light_colors.dart';
import '../utilites/widgets/app_icon.dart';
import 'forget_password.dart';
import 'loding_screen.dart';
import 'log_in/log_in.dart';

// ignore: must_be_immutable
class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  String? screenSizeDesign;

  @override
  Widget build(BuildContext context) {
    UserChange userChange = Provider.of<UserChange>(context);
    screenSizeDesign = Helper().getDesignSize(context);
    Color backColor =
        Theme.of(context).colorScheme.background == Color(0xff90caf9)
            ? LightColors.startsBackground
            : DarkColors.startsBackground;

    return userChange.authPage == AuthPage.HOME
        ? HomePage()
        : WillPopScope(
            onWillPop: () async {
              if (userChange.authPage == AuthPage.GOOGLE_SIGN_UP ||
                  userChange.authPage == AuthPage.EMAIL_SIGN_UP ||
                  userChange.authPage == AuthPage.FORGET_PASSWORD) {
                userChange.setAuthPage(AuthPage.SIGN_IN);
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      if (userChange.authPage == AuthPage.GOOGLE_SIGN_UP ||
                          userChange.authPage == AuthPage.EMAIL_SIGN_UP ||
                          userChange.authPage == AuthPage.FORGET_PASSWORD) {
                        userChange.setAuthPage(AuthPage.SIGN_IN);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                backgroundColor: backColor,
                body: userChange.authPage == AuthPage.SPLASH
                    ? SplashScreen()
                    : userChange.authPage == AuthPage.LOADING
                        ? LoadingScreen()
                        : body(userChange: userChange, context: context)),
          );
  }

  Widget body({UserChange? userChange, BuildContext? context}) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context!).unfocus(),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mobileDesign(userChange!),
                    vertDivider(),
                    space(),
                    leftColumnWidget(userChange),
                  ]),
            ),
          ),
        ));
  }

  Text title(AuthPage page) {
    String text = page == AuthPage.SIGN_IN
        ? Strings.logIn
        : page == AuthPage.GOOGLE_SIGN_UP
            ? Strings.googleSignUp
            : Strings.emailSignUp;
    return Text(text, style: TextStyles.logInLogo);
  }

  Expanded mobileDesign(UserChange userChange) {
    bool signIn = userChange.authPage == AuthPage.SIGN_IN,
        google = userChange.authPage == AuthPage.GOOGLE_SIGN_UP,
        signUpWithEP = userChange.authPage == AuthPage.EMAIL_SIGN_UP;
    return Expanded(
        child: google
            ? GoogleSignUpWidgets(formKey: formKey, userChange: userChange)
            : signIn
                ? LogIn(formKey: formKey, userChange: userChange)
                : signUpWithEP
                    ? RegisterPage(formKey: formKey, userChange: userChange)
                    : ForgetPassword(formKey: formKey, userChange: userChange));
  }

  Widget leftColumnWidget(UserChange userChange) {
    return screenSizeDesign == Strings.smallDesign
        ? Container()
        : Expanded(
            child: Column(children: [
              AppIcon(size: Size(250, 250)),
              title(userChange.authPage),
            ]),
          );
  }

  Widget space() {
    return screenSizeDesign == Strings.smallDesign
        ? Container()
        : SizedBox(
            width: 150,
          );
  }

  Widget vertDivider() {
    return screenSizeDesign == Strings.smallDesign
        ? Container()
        : VerticalDivider(
            color: Colors.white,
            width: 20,
            thickness: 10,
          );
  }
}
