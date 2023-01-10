import 'package:bionic_test/services/fcmkey.dart';
import 'package:flutter/material.dart';

class SendNotif extends StatelessWidget {
  const SendNotif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SendNotif")),
      body: Center(
        child: Text("Coming Soon.."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var token = await getFcmToken();
          print(token);
        },
      ),
    );
  }
}
