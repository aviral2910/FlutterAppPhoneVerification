import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:virtuostack/Widget/button_widget.dart';

import 'package:path/path.dart' as p;

import 'package:virtuostack/model/items_model.dart';

class EditBottomsheetContainer extends StatefulWidget {
  EditBottomsheetContainer(this.item, this.bottomSheetHeading, {Key? key})
      : super(key: key);
  final String bottomSheetHeading;
  ItemsModel item;
  @override
  State<EditBottomsheetContainer> createState() =>
      _EditBottomsheetContainerState();
}

class _EditBottomsheetContainerState extends State<EditBottomsheetContainer> {
  CollectionReference Items = FirebaseFirestore.instance.collection('items');

  Future EditItemsbtn() async {
    final bool isTitleValid = _inputtitleformKey.currentState!.validate();
    final bool isDescriptionValid =
        _inputdescriptionformKey.currentState!.validate();
    if (isTitleValid && isDescriptionValid) {
      Navigator.pushNamed(context, '/home_page');
      if (pickImagFlag == 0) {
        _imageurl = widget.item.image;
      }
      // await uploadFile(imagepath);
      return Items.doc(widget.item.ids.toString()).set({
        "ids": widget.item.ids.toString(),
        'title': _titlecontoller.text,
        'description': _descriptioncontroller.text,
        'image': _imageurl,
        'createdAt': DateTime.now(),
      });
    }
  }

  final TextEditingController _titlecontoller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final GlobalKey<FormState> _inputtitleformKey = GlobalKey();
  final GlobalKey<FormState> _inputdescriptionformKey = GlobalKey();
  var _imageurl;
  File? image;
  var imagepath;
  int pickImagFlag = 0; //it will tell if the pick image is called or not
  Future pickImage() async {
    pickImagFlag += 1;
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
//Giving path to upload image to firebase storage

    await uploadFile(image.path);

//setting path of image  to show on bottonsheet
    var imageTemporary = File(image.path);
    setState(() {
      imagepath = image.path;
      this.image = imageTemporary;
    });
  }

  Future uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('images/${p.basename(path)}'); //making the file reference
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      _imageurl = fileUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Padding(
      padding:
          const EdgeInsets.only(top: 30.0, left: 22.0, right: 22.0, bottom: 30),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom), //this padding save hiding inputfield from keyboard
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(widget.bottomSheetHeading,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () => pickImage(),
                child: image != null
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.file(
                          image!,
                          width: 140,
                          height: 140,
                        ),
                      )
                    : widget.item.image == null
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Image(
                              height: 140,
                              width: 140,
                              image: AssetImage("assets/images/logo.png"),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              widget.item.image,
                              width: 140,
                              height: 140,
                            ),
                          )),
            TextEditInputFormField(
                _titlecontoller,
                _inputtitleformKey,
                null,
                "Title",
                "Should be less then 20 Characters ",
                TextInputType.text,
                widget.item.title),
            TextEditInputFormField(
                _descriptioncontroller,
                _inputdescriptionformKey,
                null,
                "Description",
                "Should be less then 20 Characters ",
                TextInputType.text,
                widget.item.description),
            SizedBox(
                width: double.infinity,
                height: 40,
                child: Button("SAVE", EditItemsbtn))
          ],
        ),
      ),
    );
  }

  // Widget TextEditInputFormField(
  //   BuildContext context,
  //   TextEditingController controller,
  //   GlobalKey<FormState> inputformKey,
  //   IconData? icon,
  //   String hinttext,
  //   String warningMessage,
  //   TextInputType keyboardtype,
  //   String? initValue,
  // ) {
  //   final controller = TextEditingController(text: initValue);

  //   return Form(
  //     key: inputformKey,
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
  //       child: SizedBox(
  //         child: TextFormField(
  //           // key: _inputkey,
  //           controller: controller,
  //           keyboardType: keyboardtype,
  //           decoration: InputDecoration(
  //             labelText: hinttext,
  //             prefixIcon: icon == null ? null : Icon(icon),
  //             hintText: "Input",
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //           ),
  //           validator: (value) {
  //             if (value.toString().isEmpty) {
  //               return warningMessage;
  //             }
  //             return null;
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class TextEditInputFormField extends StatelessWidget {
  TextEditInputFormField(this.controller, this.inputformKey, this.icon,
      this.hinttext, this.warningMessage, this.keyboardtype, this.initValue,
      {Key? key})
      : super(key: key);

  String initValue;
  TextEditingController controller;
  GlobalKey<FormState> inputformKey;
  IconData? icon;
  String hinttext;
  String warningMessage;
  TextInputType keyboardtype;

  @override
  Widget build(BuildContext context) {
    controller.text = initValue;
    return Form(
      key: inputformKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: SizedBox(
          child: TextFormField(
            // key: _inputkey,
            controller: controller,
            keyboardType: keyboardtype,
            decoration: InputDecoration(
              labelText: hinttext,
              prefixIcon: icon == null ? null : Icon(icon),
              hintText: "Input",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              controller.text = value.toString();
              if (value.toString().isEmpty || value.toString().length > 40) {
                return warningMessage;
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
