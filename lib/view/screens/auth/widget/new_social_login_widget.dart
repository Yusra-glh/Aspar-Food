import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/body/social_log_in_body.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sixam_mart/util/styles.dart';

class NewSocialLoginWidget extends StatelessWidget {
  const NewSocialLoginWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    return Get.find<SplashController>().configModel.socialLogin.isNotEmpty &&
            (Get.find<SplashController>().configModel.socialLogin[0].status ||
                Get.find<SplashController>().configModel.socialLogin[1].status)
        ? Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Get.find<SplashController>().configModel.socialLogin[0].status
                ? Padding(
                    padding:
                        EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: InkWell(
                      onTap: () async {
                        GoogleSignInAccount _googleAccount =
                            await _googleSignIn.signIn();
                        GoogleSignInAuthentication _auth =
                            await _googleAccount.authentication;
                        if (_googleAccount != null) {
                          Get.find<AuthController>()
                              .loginWithSocialMedia(SocialLogInBody(
                            email: _googleAccount.email,
                            token: _auth.idToken,
                            uniqueId: _googleAccount.id,
                            medium: 'google',
                          ));
                        }
                      },
                      child: Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL),
                              child: Image.asset(
                                Images.google,
                                height: 30,
                                width: 20,
                              ),
                            ),
                            Text('Google'.tr,
                                style: robotoBold.copyWith(
                                    fontSize: 17, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(
                width: Get.find<SplashController>()
                        .configModel
                        .socialLogin[0]
                        .status
                    ? Dimensions.PADDING_SIZE_SMALL
                    : 0),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Get.find<SplashController>().configModel.socialLogin[1].status
                ? InkWell(
                    onTap: () async {
                      LoginResult _result = await FacebookAuth.instance.login();
                      if (_result.status == LoginStatus.success) {
                        Map _userData =
                            await FacebookAuth.instance.getUserData();
                        if (_userData != null) {
                          Get.find<AuthController>()
                              .loginWithSocialMedia(SocialLogInBody(
                            email: _userData['email'],
                            token: _result.accessToken.token,
                            uniqueId: _result.accessToken.userId,
                            medium: 'facebook',
                          ));
                        }
                      }
                    },
                    child: Container(
                      height: 44,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding:
                          EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(59, 91, 148, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300],
                              spreadRadius: 1,
                              blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: Dimensions.PADDING_SIZE_SMALL),
                            child: Image.asset(
                              Images.newFacebook,
                              height: 30,
                              width: 20,
                            ),
                          ),
                          Text('Facebook'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: 17, color: Colors.white)),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          ])
        : SizedBox();
  }
}
