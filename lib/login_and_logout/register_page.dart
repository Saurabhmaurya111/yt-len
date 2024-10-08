// import 'dart:js_interop';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_moment/components/custom_button.dart';
import 'package:last_moment/components/custom_textfield.dart';
import 'package:last_moment/components/square_tile.dart';
import 'package:last_moment/login_and_logout/auth_services.dart';
import 'package:lottie/lottie.dart';


class RegisterPage extends StatefulWidget {
  final Function()?onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmedpasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if(passwordController.text == confirmedpasswordController.text){

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      }else{
        showErrorMessage("Passwords don't match!");
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
     showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          title: Center(
            child: Text(
              message,
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        TextLiquidFill(
                            text: 'Last_Moment',
                            waveColor: Colors.blueAccent,
                            boxBackgroundColor:
                                Color.fromRGBO(224, 224, 224, 1),
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                            ),
                            boxHeight: 45.0,
                            boxWidth:218,
                          ),
                    // Container(
                    //     height: 70,
                    //     color: Colors.transparent,
                    //     child: Lottie.asset('assets/log.json',
                    //         fit: BoxFit.contain))
                  ],
                ),

                SizedBox(
                  height: 30,
                ),
                Text(
                  "Create your Account",
                  style: TextStyle(
                      color: Color.fromARGB(255, 66, 66, 66), fontSize: 16),
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextfiled(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextfiled(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextfiled(
                  controller: confirmedpasswordController,
                  hintText: 'Confirmed Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
               
                SizedBox(
                  height: 25,
                ),
                CustomButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or sign up with",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'assets/google.png'),
                    const SizedBox(
                      width: 15,
                    ),
                    SquareTile(
                      onTap: (){

                      },
                      imagePath: 'assets/facebook.jpg'),
                    const SizedBox(
                      width: 15,
                    ),
                    SquareTile(
                      onTap: (){
                        
                      },
                      imagePath: 'assets/apple.png'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login now",
                        style: TextStyle(
                            color: const Color.fromRGBO(33, 150, 243, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
