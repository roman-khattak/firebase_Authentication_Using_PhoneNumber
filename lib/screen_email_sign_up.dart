
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_urraan/screen_phone_authentication.dart';
import 'package:firebase_urraan/utilities.dart';

class ScreenEmailSignUp extends StatefulWidget {
  const ScreenEmailSignUp({Key? key}) : super(key: key);

  @override
  State<ScreenEmailSignUp> createState() => _ScreenEmailSignUpState();
}

class _ScreenEmailSignUpState extends State<ScreenEmailSignUp> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var firebase_auth = FirebaseAuth.instance; // created an instnce;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen Email Sign Up"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: AutofillHints.email),
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: AutofillHints.password),
                controller: passwordController,
              ),
            ),


              Row(
                children: [
                  TextButton(
                    onPressed: (){

                      String email = emailController.text.toString();
                      String password = passwordController.text.toString();

                      try{
                        firebase_auth.createUserWithEmailAndPassword(email: email, password: password)
                            .then((UserCredential user_credential){
                              print("object 1 ${user_credential.user.toString()}");
                              print("object 2 ${user_credential.credential!.signInMethod}");
                              print("object 3 ${user_credential.credential!.token}");
                        }).onError((FirebaseAuthException error, stackTrace) {
                          print("error : error.code ${error.code}");                          // handling the exceptions (errors)
                          if(error.code == "weak-password") {                                        // type of error in code
                           print("Password should be at least 6 characters");                   // message to display for such error
                          }

                          else if (error.code == "email-already-in-use") {
                            print("object ${error.toString()}");
                          }

                          else if (error.code == "too-many-requests") {
                            print("object ${error.toString()}");
                          }

                        });
                      }
                      catch(e){
                        print("object Error: ${e.toString()}");
                        return;
                      }


                    },
                    child: Text("Sign up with email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black87),),
                  ),

                  TextButton(
                    onPressed: (){

                      String email = emailController.text.toString();
                      String password = passwordController.text.toString();

                      try{
                        firebase_auth.signInWithEmailAndPassword(email: email, password: password)
                            .then((UserCredential user_credential){
                          print("object 1 ${user_credential.user.toString()}");
                          print("object 2 ${user_credential.credential!.signInMethod}");
                          print("object 3 ${user_credential.credential!.token}");
                        }).onError((FirebaseAuthException error, stackTrace) {             // handling the exceptions (errors)
                          if(error.code == "wrong-password") {                      // type of error in code
                            print("The password is invalid");      // message to display for such error
                          }
                        });
                      }
                      catch(e){
                        print("object Error: ${e.toString()}");
                        return;
                      }
                    },

                    child: Text("Sign in with email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black87),),
                  ),
                ],
              ),

        Row(
          children: [

            /*
            Note: if you signout as normal user then sign in as anonymous so current user will be "isAnonymous = True"
            and if you signout of anonymous user and then sign in as normal user then current user will be the email with which you signed in.
            */
            Padding(
              padding: const EdgeInsets.all(1.0),    //margins are reduced so that the button do not exceed the Screen Row size and can adjust inside the house.
              child: TextButton(
                onPressed: (){
          //Anonymous function used to sign in anonymoously
                  try{
                    firebase_auth.signInAnonymously()         // return type Future<user credentials>
                        .then((value){
                      print("object 1 ${firebase_auth.currentUser.toString()}");

                    }).onError((FirebaseAuthException error, stackTrace) {
                      print("error : error.code ${error.code}");                          // handling the exceptions (errors)
                      if(error.code == "weak-password") {                                        // type of error in code
                        print("Password should be at least 6 characters");                   // message to display for such error
                      }

                      else if (error.code == "email-already-in-use") {
                        print("object ${error.toString()}");
                      }

                      else if (error.code == "too-many-requests") {
                        print("object ${error.toString()}");
                      }

                    });
                  }
                  catch(e){
                    print("object Error: ${e.toString()}");
                    return;
                  }


                },
                child: Text("Anonymous", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black87),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: (){

                  try{
                    firebase_auth.signOut();
                  }
                  catch(e){
                    print("object Error: ${e.toString()}");
                    return;
                  }
                },

                child: Text("Sign Out", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black87),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: (){

                  try{
                    print("object ${firebase_auth.currentUser.toString()}");
                  }
                  catch(e){
                    print("object Error: ${e.toString()}");
                    return;
                  }
                },

                child: Text("Current User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black87),),
              ),
            ),


          ],
        ),
            SizedBox(height: 70,),   // SizedBox is placed here to push the row down on the screen

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScreenPhoneAuthentication();
                },)
                );
              },
                  child: Text("Phone Authentication",style: TextStyle(fontSize: 18),)
              ),
            ],
            )
          ],
        ),
      ),
    );
  }
}
