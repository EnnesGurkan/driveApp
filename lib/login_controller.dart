import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as googleApi;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class LoginController extends GetxController {
  var _googleSignin = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  var driveSignin =
      GoogleSignIn.standard(scopes: [googleApi.DriveApi.driveScope]);

  login() async {
    googleAccount.value = await _googleSignin.signIn();
  }

  logout() async {
    googleAccount.value = await _googleSignin.signOut();
  }

  driveSign() async {
    googleAccount.value = await driveSignin.signIn();
  }

  driveUplod() async {
    final GoogleSignInAccount? account = await driveSignin.signIn();

    final authHeaders = await account?.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders!);
    final driveApi = googleApi.DriveApi(authenticateClient);
    final Stream<List<int>> mediaStream =
        Future.value([104, 105]).asStream().asBroadcastStream();
    var media = new googleApi.Media(mediaStream, 2);
    var driveFile = new googleApi.File();
    driveFile.name = "Sedat.txt";
    final result = await driveApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");
  }

  driveUplodFile() async {
    final GoogleSignInAccount? account = await driveSignin.signIn();
    final authHeaders = await account?.authHeaders;
    var client = GoogleAuthClient(authHeaders!);

    var drive = googleApi.DriveApi(client);
    googleApi.File fileToUpload = googleApi.File();
    var result = await FilePicker.platform.pickFiles();
    final file = result!.files.first;
    fileToUpload.parents = ["DRIVETEST"];
    fileToUpload.name = path.basename(file.name);

    Stream<List<int>>? content = file.readStream;
    var response = await drive.files.create(
      fileToUpload,
      uploadMedia: googleApi.Media(content!, file.size),
    );
    print(response);
    //_listGoogleDriveFiles();
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
