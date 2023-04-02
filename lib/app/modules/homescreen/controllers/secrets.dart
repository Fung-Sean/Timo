import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      //"763150906246-2qg98u46ktp09bvasbadlk948tfa2ucc.apps.googleusercontent.com";
      "";
  static const IOS_CLIENT_ID =
      "763150906246-jhrqn6r1ekpo27e8tq2ec1qe78421e5h.apps.googleusercontent.com";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}
