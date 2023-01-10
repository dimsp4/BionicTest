import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  List<AssetEntity> assets = [];
  List<Widget> assetsClicked = [];

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final permitted = await PhotoManager.requestPermissionExtend();

    if (permitted.isAuth) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      final recentAlbum = albums.first;

      // Now that we got the album, fetch all the assets it contains
      final recentAssets = await recentAlbum.getAssetListRange(
        start: 0, // start at index 0
        end: 1000, // end at a very big index (to get all the assets)
      );

      // Update the state and notify UI
      setState(() => assets = recentAssets);
    } else {
      return;
    }
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  children: assetsClicked,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Builder(builder: (context) {
                    return TextButton(
                      onPressed: () async {
                        showFlexibleBottomSheet<void>(
                          minHeight: 0,
                          initHeight: 0.5,
                          maxHeight: 1,
                          context: context,
                          bottomSheetColor: Colors.white,
                          builder: (context, controller, offset) {
                            if (assets.isEmpty) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return GridView.builder(
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: assets.length,
                                itemBuilder: (_, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      assetsClicked.add(
                                        AssetThumbnail(
                                          asset: assets[index],
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      child: AssetThumbnail(
                                        asset: assets[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          anchors: [0, 0.5, 1],
                        );
                      },
                      child: Text('Open Gallery'),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
