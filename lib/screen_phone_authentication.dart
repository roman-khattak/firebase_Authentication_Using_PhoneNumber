
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScreenPhoneAuthentication extends StatefulWidget {
  const ScreenPhoneAuthentication({Key? key}) : super(key: key);

  @override
  State<ScreenPhoneAuthentication> createState() => _ScreenPhoneAuthenticationState();
}

class _ScreenPhoneAuthenticationState extends State<ScreenPhoneAuthentication> {

  var phoneNumberController = TextEditingController();
  var codeController = TextEditingController();

  var firebase_auth = FirebaseAuth.instance; // created an instnce to access all the features of firebase

  String verificationId = "";

  bool isCodeSent = false; // its false because the code is not sent yet, i.e., it will be sent in future
  @override
  void initState() {
    super.initState();
  }

  PhoneNumberAuthComplete(BuildContext context, sms_code) async{          // another argument is created for credential "sms_code"

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: sms_code);

    firebase_auth                                  // When you click on "Verify code" this code will make make you " 'sign in' with the credentials"
        .signInWithCredential(credential)
        .then((UserCredential user_credential) {
      print("object ${user_credential.user.toString()}");
    });
  }

  VerifyPhoneNumber(BuildContext context) async{

    String phoneNo = phoneNumberController.text.toString();  // The phonenumber is received as a text in TextFormField

    try{

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${phoneNo}',
        timeout: const Duration(seconds: 20),

        verificationCompleted: (PhoneAuthCredential credential) {  //Automatically completed the verification  // the verificationId coming from (PhoneAuthCredential credential) is assigned to "this.verificationId"
          this.verificationId = credential.verificationId!;     //used at the end while 'Code Submission"

          setState(() {

            codeController.text = credential.smsCode!;   //this function will automatically receive the verification code from "verificationCompleted" if simCard is in the same phone
          });                                //in "ios operating system" this process doesn't work automatically so you have to do it manually

          print("Hello FirebaseAuth 1 ${credential.smsCode}");
          PhoneNumberAuthComplete(context,credential.smsCode); // if "simCard" is in the same phone so we can automatically get 'smsCode' from 'credential'

        },


        verificationFailed: (FirebaseAuthException e) {
          print("Hello FirebaseAuth verification Failed Called ${e.toString()}");
        },


        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;          // "this.verificationId" is the variable of this class while on it is  stored the "verificationId" method
          setState(() {
            isCodeSent = true;
          });
          print("Hello FirebaseAuth codeSent");
        },


        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          print("Hello FirebaseAuth codeAutoRetrieval Timeout Called");
        },
      );
      /* Question: how is the argument in below code just an 'underscore sign' ?    ________________________________________*/
      //Answer: if you donot want to perform any operation with an argument ie; it is useless to you so you can just send an "_" instead of argument
      //...ie; { on FirebaseAuthException catch(_, __) }. Thus the first argument become "_" and second one become "__"
    }on FirebaseAuthException catch(error, _) {        //"on" statement used for Known Errors
     print("Hello FirebaseAuth FirebaseAuthException Called ${error.toString()}");
    }

    catch(e){
        print("Hello FirebaseAuth error Occured ${e.toString()}");
    }
  }
  Widget build(BuildContext context) {

    GestureTapCallback onTapVerify = () {   // We placed "GestureTap" on 'VerifyPhoneNumber' button
      if(!isCodeSent) {           // '!'is placed before "isCodeSent" variable because it is always placed before variable and after the datatype
                                  // "isCodeSent" is false by default
        VerifyPhoneNumber(context);
      }
      else{
        String code_sms = codeController.text.toString();
        PhoneNumberAuthComplete(context, code_sms);    // this mehtod works when "simCard" is in another phone and we are verifying it in someother phone by clicking button manualy then we use it
      }
    };

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
                decoration: InputDecoration(hintText: "Enter phone number"),
                controller: phoneNumberController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: "Enter verification code"),
                controller: codeController,
              ),
            ),


            Row(
              children: [
                TextButton(
                  onPressed: onTapVerify,
                  child: Text(
                    // isCodeSent = false; by default and in the below line of code the first statement is for 'true' and 2nd one is for 'false'
                    //thus when isCodeSent = false so button text = "Verify Phone Number" and when isCodeSent = true so button text = "Verify Code"
                    isCodeSent ? "Verify Code" : "Verify Phone Number",      // until code is not sent the button name will be "verify Phone NUmber" and when code is sent then the button name will change to "verify code"
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black87),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}