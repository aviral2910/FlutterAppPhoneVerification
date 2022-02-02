import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtuostack/Widget/button_widget.dart';
import 'package:virtuostack/Widget/input_form_field.dart';
import 'package:virtuostack/Widget/text_input_field.dart';
import 'package:path/path.dart' as p;
import 'package:virtuostack/controller/fethc_item_controller.dart';

class BottomsheetContainer extends StatefulWidget {
  const BottomsheetContainer(this.bottomSheetHeading, {Key? key})
      : super(key: key);
  final String bottomSheetHeading;
  @override
  State<BottomsheetContainer> createState() => _BottomsheetContainerState();
}

class _BottomsheetContainerState extends State<BottomsheetContainer> {
  CollectionReference Items = FirebaseFirestore.instance.collection('items');
  CollectionReference counter =
      FirebaseFirestore.instance.collection('counter');

  Future SubmitItems() async {
    final bool isTitleValid = _inputtitleformKey.currentState!.validate();
    final bool isDescriptionValid =
        _inputdescriptionformKey.currentState!.validate();
    if (isTitleValid && isDescriptionValid) {
      var counter =
          await FirebaseFirestore.instance.collection('counter').get();
      int itemid = counter.docs[0].data()['countid'];
      int increamneteditemid = itemid + 1;
      // And do something here
      FirebaseFirestore.instance
          .collection('counter')
          .doc("0")
          .set({'countid': increamneteditemid});
      Navigator.pushNamed(context, '/home_page');

      // await uploadFile(imagepath);
      return Items.doc(itemid.toString()).set({
        "ids": itemid.toString(),
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
  Future pickImage() async {
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

  void _saveForm() {}

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
                    : const Icon(
                        Icons.image,
                        size: 140,
                        color: Colors.black,
                      )),
            TextInputFormField(
                TextInputType.text,
                _titlecontoller,
                _inputtitleformKey,
                null,
                "Title",
                "Should be less then 20 characters "),
            TextInputFormField(
              TextInputType.text,
              _descriptioncontroller,
              _inputdescriptionformKey,
              null,
              "Description",
              "Should be less then 20 characters ",
            ),
            SizedBox(
                width: double.infinity,
                height: 40,
                child: Button("SAVE", SubmitItems))
          ],
        ),
      ),
    );
  }

  // bool validator(String value, String WarningMesssage) {
  //   if (value.toString().isEmpty || value.toString().length > 20) {
  //     return false;
  //   }
  //   return true;
  // }
}

class CounterModel {
  String countid;
  CounterModel(this.countid);
}
