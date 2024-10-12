import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loginscreen/animation_enum.dart';
import 'package:rive/rive.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Artboard? riveartboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String testEmail = 'hazemzohdy@gmail.com';
  String testPassWord = '123456789';
  final passWordFocusNode = FocusNode();
  bool isleft = false;
  bool isright = false;

  void removeAllController() {
    riveartboard?.artboard.removeController(controllerIdle);
    riveartboard?.artboard.removeController(controllerHandsUp);
    riveartboard?.artboard.removeController(controllerHandsDown);
    riveartboard?.artboard.removeController(controllerFail);
    riveartboard?.artboard.removeController(controllerSuccess);
    riveartboard?.artboard.removeController(controllerLookLeft);
    riveartboard?.artboard.removeController(controllerLookRight);
    isleft = false;
    isright = false;
  }

  void AddIdelController() {
    removeAllController();
    riveartboard?.artboard.addController(controllerIdle);
    debugPrint('Ideel');
  }

  void AddHandsUpController() {
    removeAllController();
    riveartboard?.artboard.addController(controllerHandsUp);
    debugPrint('HandsUp');
  }

  void AddHandsDownController() {
    removeAllController();
    riveartboard?.artboard.addController(controllerHandsDown);
    debugPrint('HandsDown');
  }

  void addFailController() {
    removeAllController();
    riveartboard?.artboard.addController(controllerFail);
    debugPrint('Fail');
  }

  void AddSuccessController() {
    removeAllController();
    riveartboard?.artboard.addController(controllerSuccess);
    debugPrint('Success');
  }

  void AddLookleftController() {
    removeAllController();
    isleft = true;
    riveartboard?.artboard.addController(controllerLookLeft);
    debugPrint('LookLeft');
  }

  void AddLookRightController() {
    removeAllController();
    isright = true;
    riveartboard?.artboard.addController(controllerLookRight);
    debugPrint('LookRight');
  }

  void checkForPassWordAnmated() {
    passWordFocusNode.addListener(() {
      if (passWordFocusNode.hasFocus) {
        AddHandsUpController();
      } else if (!passWordFocusNode.hasFocus) {
        AddHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);

    rootBundle.load('assets/animated_login_screen.riv').then((data) {
      final file = RiveFile.import(data);

      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveartboard = artboard;
      });
    });
    checkForPassWordAnmated();
  }

  void validateEmailAndPassWord() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formkey.currentState!.validate()) {
        AddSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Login LoL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: riveartboard == null
                  ? const SizedBox.shrink()
                  : Rive(
                      artboard: riveartboard!,
                    ),
            ),
            Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    validator: (value) =>
                        value != testEmail ? 'wroge passWord ' : null,
                    onChanged: (value) {
                      if (value.isNotEmpty && value.length < 16 && !isleft) {
                        AddLookleftController();
                      } else if (value.isNotEmpty &&
                          value.length > 16 &&
                          !isright) {
                        AddLookRightController();
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'passWord',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    focusNode: passWordFocusNode,
                    validator: (value) =>
                        value != testPassWord ? 'wroge passWord ' : null,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  Container(
                    height: 55,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 14,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        passWordFocusNode.unfocus();
                        validateEmailAndPassWord();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
