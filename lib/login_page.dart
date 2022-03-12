import 'package:flutter/material.dart';
import 'package:fluttersignin/login_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LoginPage")),
      body: Center(child: Obx(
        () {
          if (controller.googleAccount.value == null) {
            return signin();
          } else
            return profile();
        },
      )),
    );
  }

  signin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (() {
            print("TEST");
            controller.login();
          }),
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Google"),
              ),
              decoration:
                  BoxDecoration(color: Colors.amber, border: Border.all()),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        ActionChip(
            label: Text("DriverSign"),
            onPressed: () {
              controller.driveSign();
            }),
      ],
    );
  }

  profile() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage:
                Image.network(controller.googleAccount.value?.photoUrl ?? '')
                    .image,
            radius: 100,
          ),
          Text(
            controller.googleAccount.value?.displayName ?? '',
            style: Get.textTheme.headline4,
          ),
          Text(
            controller.googleAccount.value?.email ?? '',
            style: Get.textTheme.bodyText2,
          ),
          SizedBox(
            height: 25,
          ),
          ActionChip(
              avatar: Icon(Icons.logout),
              label: Text('upload'),
              onPressed: () {
                controller.driveUplodFile();
              }),
          ActionChip(
              avatar: Icon(Icons.logout),
              label: Text('Logout'),
              onPressed: () {
                controller.logout();
              })
        ],
      ),
    );
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
