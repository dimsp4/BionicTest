import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Widget> daftarKontak = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MapPage")),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Column(
              children: daftarKontak,
            ),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                initialChildSize: 0.25,
                minChildSize: 0.12,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 45,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.black38,
                              hintText: "Search Contact",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: getContacts(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Contact contact = snapshot.data[index];
                                    return GestureDetector(
                                      onTap: (() => setState(
                                            () {
                                              daftarKontak.add(
                                                ListTile(
                                                  leading: const CircleAvatar(
                                                    radius: 20,
                                                    child: Icon(Icons.person),
                                                  ),
                                                  title:
                                                      Text(contact.displayName),
                                                  subtitle: Text(
                                                    "email@company.com",
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                      child: Column(children: [
                                        ListTile(
                                          leading: const CircleAvatar(
                                            radius: 20,
                                            child: Icon(Icons.person),
                                          ),
                                          title: Text(contact.displayName),
                                          subtitle: Text(
                                            "email@company.com",
                                          ),
                                        ),
                                        const Divider()
                                      ]),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: SizedBox(
                                    height: 50,
                                    child: CircularProgressIndicator()),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
  }
}
