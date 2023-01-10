import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  List<Widget> daftarLagu = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Page")),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Column(
              children: daftarLagu,
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
                              hintText: "Search Audio",
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
                          future: _audioQuery.querySongs(
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      textColor: Colors.black,
                                      title: Text(snapshot.data![index].title),
                                      subtitle: Text(
                                        snapshot.data![index].displayName,
                                      ),
                                      trailing: const Icon(Icons.more_vert),
                                      leading: QueryArtworkWidget(
                                        id: snapshot.data![index].id,
                                        type: ArtworkType.AUDIO,
                                      ),
                                      onTap: () {
                                        // daftarLagu.add(value);
                                        setState(() {
                                          daftarLagu.add(
                                            ListTile(
                                              textColor: Colors.black,
                                              title: Text(
                                                  snapshot.data![index].title),
                                              subtitle: Text(
                                                snapshot
                                                    .data![index].displayName,
                                              ),
                                              trailing:
                                                  const Icon(Icons.more_vert),
                                              leading: QueryArtworkWidget(
                                                id: snapshot.data![index].id,
                                                type: ArtworkType.AUDIO,
                                              ),
                                            ),
                                          );
                                        });
                                      },
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

  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      //ensure build method is called
      setState(() {});
    }
  }
}
