import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/helperFunctions.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  final Function function;
  ImageCapture({this.function});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  PickedFile _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await ImagePicker().getImage(source: source, imageQuality: 50);
    setState(() {
      _imageFile = selected;
    });
  }


  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "edit your profile pic",
          backgroundColor: Colors.white,
          toolbarColor: Colors.blue[50],
          toolbarWidgetColor: Colors.blue,
          activeControlsWidgetColor: Colors.blue,
        ));
    PickedFile pickedFile =
        PickedFile(cropped == null ? _imageFile.path : cropped.path);
    setState(() {
      _imageFile = pickedFile ?? _imageFile;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        backgroundColor: Colors.white,
        body: _imageFile == null
            ? getBodyWhenFileNotPresent()
            : getBodyWhenFilePresent(),
        bottomNavigationBar: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  heroTag: "btn4",
                  elevation: 0,
                  backgroundColor: Colors.blue[50],
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                FloatingActionButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    heroTag: "btn5",
                    elevation: 0,
                    backgroundColor: Colors.blue[50],
                    child: Icon(
                      Icons.photo_library,
                      color: Colors.blue,
                      size: 30,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBodyWhenFilePresent() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Center(
            child: Container(
              child: Wrap(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      if (_imageFile != null) ...[
                        Center(
                          child: Container(
                              color: Colors.grey[100],
                              padding: EdgeInsets.all(4),
                              child: Image.file(
                                File(_imageFile.path),
                                height: width * 1.2,
                              )),
                        )
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              margin: EdgeInsets.all(10),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                        onPressed: _cropImage,
                        heroTag: "btn1",
                        backgroundColor: Colors.blue[50],
                        elevation: 0,
                        child: Icon(
                          Icons.crop,
                          color: Colors.blue,
                        )),
                    FloatingActionButton(
                        onPressed: () async {
                          String base64String = Utility.base64String(
                              File(_imageFile.path).readAsBytesSync());
                          if (File(_imageFile.path).readAsBytesSync().length >=
                              800000) {
                            showDialogue(context, 'Image size is too big');
                            return;
                          }
                          await Utility.saveImageToPreferences(base64String);
                          if (widget.function != null) {
                            Future.delayed(Duration(seconds: 2), () {
                              widget.function();
                            });
                          }
                          Navigator.of(context).pop();
                          // Center(
                          //   child: CircularProgressIndicator(),
                          // );
                          // FirebaseFireStoreServices.updateUserImage(base64String);

                          // Phoenix.rebirth(context);
                          // Future.delayed(Duration(seconds: 5), ()=>Phoenix.rebirth(context));
                        },
                        heroTag: "btn2",
                        backgroundColor: Colors.blue[50],
                        elevation: 0,
                        child: Icon(
                          Icons.save,
                          color: Colors.blue,
                        )),
                    FloatingActionButton(
                        onPressed: _clear,
                        heroTag: "btn3",
                        backgroundColor: Colors.blue[50],
                        elevation: 0,
                        child: Icon(
                          Icons.refresh,
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBodyWhenFileNotPresent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file,
            color: Colors.blue[50],
            size: MediaQuery.of(context).size.width * 0.5,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Grab your Profile Pic",
              style: TextStyle(color: Colors.grey[500]),
            ),
          )
        ],
      ),
    );
  }

  appBar() {
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Container(
        padding: EdgeInsets.all(10),
        // height: 40,
        width: width / 2,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "grab your profile pic",
            style: GoogleFonts.muli(
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
