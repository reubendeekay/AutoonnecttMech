import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechanic_admin/drawer/hidden_drawer.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/my_loader.dart';
import 'package:mechanic_admin/mechanic/add_service.dart';
import 'package:mechanic_admin/mechanic/mechanic_register/add_on_map.dart';
import 'package:mechanic_admin/mechanic/mechanic_register/widgets/time_picker.dart';
import 'package:mechanic_admin/mechanic/mechanic_upload_documents.dart';

import 'package:mechanic_admin/models/mechanic_model.dart';
import 'package:mechanic_admin/providers/admin_user_provider.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/location_provider.dart';

import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:provider/provider.dart';

class MechanicRegisterScreen extends StatefulWidget {
  const MechanicRegisterScreen({Key? key}) : super(key: key);
  static const routeName = 'mechanic_admin-register-screen';

  @override
  State<MechanicRegisterScreen> createState() => _MechanicRegisterScreenState();
}

class _MechanicRegisterScreenState extends State<MechanicRegisterScreen> {
  List<Media> mediaList = [];
  File? coverFile;
  List<File> imageFiles = [];
  String? name;
  String? phone;
  String? description;
  String? address;
  PickedTime? openingTime;
  PickedTime? closingTime;
  LatLng? location;
  List<dynamic> services = [];
  bool isLoading = false;
  File? nationalId;
  File? permit;

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: const Text(
                'Become a Mechanic',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  border: Border.all(
                      width: 1, color: kPrimaryColor.withOpacity(0.1))),
              child: GestureDetector(
                onTap: () {
                  openImagePicker(context, true);
                },
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: coverFile != null
                      ? Image.file(
                          coverFile!,
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                            Text(
                              'Cover image',
                              style: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5)),
                            )
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              hint: 'Mechanic Name',
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hint: 'Phone number',
              onChanged: (val) {
                setState(() {
                  phone = val;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hint: 'About Mechanic',
              onChanged: (val) {
                setState(() {
                  description = val;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return MyTimePicker(
                          onTimeChange: (val1, val2) {
                            setState(() {
                              openingTime = val1;
                              closingTime = val2;
                            });
                          },
                        );
                      });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Opening and Closing Time'),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        if (openingTime != null)
                          Text(
                              (openingTime!.h < 10
                                      ? '0' '${openingTime!.h}'
                                      : '${openingTime!.h}') +
                                  ' : ${(openingTime!.m < 10 ? '0' '${openingTime!.m}' : '${openingTime!.m}')}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        const SizedBox(
                          width: 15,
                        ),
                        if (openingTime != null)
                          const Text(
                            ' to ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(
                          width: 15,
                        ),
                        if (closingTime != null)
                          Text(
                              (closingTime!.h < 10
                                      ? '0' '${closingTime!.h}'
                                      : '${closingTime!.h}') +
                                  ' : ${(closingTime!.m < 10 ? '0' '${closingTime!.m}' : '${closingTime!.m}')}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                      ],
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              hint: 'Address',
              onChanged: (val) {
                setState(() {
                  address = val;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Operational Location'),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  Get.to(() => AddOnMap());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (loc.latitude == null)
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: OutlineButton(
                            onPressed: () => Get.to(() => AddOnMap()),
                            child: const Text('Select exact location on map')),
                      ),
                    if (loc.latitude == null)
                      const SizedBox(
                        height: 5,
                      ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        if (loc.longitude != null)
                          Text(
                              '${loc.latitude!.toStringAsFixed(4)}, ${loc.longitude!.toStringAsFixed(4)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                      ],
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            const Text('Your Photos'),
            const SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      openImagePicker(context, false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      color: kPrimaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.add,
                        color: kPrimaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ...List.generate(
                      imageFiles.length,
                      (index) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.file(
                                  imageFiles[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: -5,
                                  right: -5,
                                  child: GestureDetector(
                                    onTap: () {
                                      imageFiles.remove(imageFiles[index]);
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.cancel,
                                        color: Colors.pinkAccent),
                                  ))
                            ],
                          ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 45,
              child: RaisedButton(
                  color: kPrimaryColor,
                  onPressed: () {
                    Get.to(() => AddServices(
                          onCompleted: (val) {
                            setState(() {
                              services = val;
                            });
                          },
                        ));
                    print(services.length);
                  },
                  child: const Text(
                    'Add Your Services',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              child: RaisedButton(
                  color: kPrimaryColor,
                  onPressed: () {
                    Get.to(() => MechanicUploadDocuments(
                          onUpload: (val1, val2) {
                            setState(() {
                              nationalId = val1;
                              permit = val2;
                            });
                          },
                        ));
                  },
                  child: const Text(
                    'Upload Verification Documents',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              child: RaisedButton(
                onPressed: services.isEmpty ||
                        openingTime == null ||
                        closingTime == null ||
                        address == null ||
                        loc.latitude == null ||
                        loc.longitude == null ||
                        imageFiles.isEmpty ||
                        coverFile == null ||
                        nationalId == null ||
                        permit == null
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        await Provider.of<AdminUserProvider>(context,
                                listen: false)
                            .registerMechanic(MechanicModel(
                          address: address,
                          openingTime: (openingTime!.h < 10
                                  ? '0' '${openingTime!.h}'
                                  : '${openingTime!.h}') +
                              ' : ${(openingTime!.m < 10 ? '0' '${openingTime!.m}' : '${openingTime!.m}')}',
                          description: description,
                          fileImages: imageFiles,
                          location: GeoPoint(
                            loc.latitude!,
                            loc.longitude!,
                          ),
                          isBusy: false,
                          phone: phone!,
                          closingTime: (closingTime!.h < 10
                                  ? '0' '${closingTime!.h}'
                                  : '${closingTime!.h}') +
                              ' : ${(closingTime!.m < 10 ? '0' '${closingTime!.m}' : '${closingTime!.m}')}',
                          profileFile: coverFile,
                          name: name!,
                          services: services,
                          nationalIdFile: nationalId!,
                          permitFile: permit!,
                        ));
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (ctx) => const AlertDialog(
                                  title: Text('Registration Successful'),
                                  content:
                                      Text('Wait for approval from the admin'),
                                ));
                      },
                color: kPrimaryColor,
                child: isLoading
                    ? const MyLoader()
                    : const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openImagePicker(
    BuildContext context,
    bool isCover,
  ) async {
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPick: (selectedList) {
                        setState(() => mediaList = selectedList);

                        if (isCover) {
                          coverFile = mediaList.first.file;
                          mediaList.clear();
                        }

                        if (!isCover) {
                          for (var element in mediaList) {
                            imageFiles.add(element.file!);
                          }
                          mediaList.clear();
                        }

                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount:
                          isCover ? MediaCount.single : MediaCount.multiple,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeButtonStyle: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white),
                          ),
                        ),
                        completeText: 'Select',
                        completeTextStyle: const TextStyle(color: Colors.white),
                      ),
                    )),
              ));
        });
  }
}

class MyTextField extends StatefulWidget {
  MyTextField({Key? key, this.hint, this.onChanged}) : super(key: key);

  String? hint;
  Function(String value)? onChanged;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: null,
      maxLines: null,
      onChanged: (val) {
        setState(() {
          widget.onChanged!(val);
        });
      },
      validator: (val) {
        if (val!.isEmpty) {
          return 'Enter the ${widget.hint!}';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none,
          fillColor: kPrimaryColor.withOpacity(0.1),
          filled: true),
    );
  }
}
