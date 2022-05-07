import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/cached_image.dart';

import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/my_loader.dart';
import 'package:mechanic_admin/models/service_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/mechanic_provider.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({Key? key, required this.service}) : super(key: key);
  final ServiceModel service;

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  String? name, price;
  File? imageFile;
  bool isLoading = false;
  bool isDeleting = false;
  List<Media> mediaList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final id = Provider.of<AuthProvider>(context, listen: false).mechanic!.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Service'),
        backgroundColor: kPrimaryColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
                child: Column(children: [
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      openImagePicker(context);
                    },
                    child: SizedBox(
                      height: size.height * 0.3,
                      width: size.width,
                      child: cachedImage(
                        widget.service.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300]),
                    child: TextFormField(
                        initialValue: widget.service.serviceName!,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter the name of the service';
                          }

                          return null;
                        },
                        maxLength: null,
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'Name of service',
                            helperStyle: const TextStyle(color: kPrimaryColor),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kPrimaryColor, width: 1)),
                            border: InputBorder.none),
                        onChanged: (text) => {
                              setState(() {
                                name = text;
                              })
                            }),
                  ),
                  Container(
                    width: size.width,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300]),
                    child: TextFormField(
                        initialValue: widget.service.price!,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter the name of the service';
                          }

                          return null;
                        },
                        maxLength: null,
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'Price of service',
                            helperStyle: const TextStyle(color: kPrimaryColor),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kPrimaryColor, width: 1)),
                            border: InputBorder.none),
                        onChanged: (text) => {
                              setState(() {
                                price = text;
                              })
                            }),
                  ),
                  const Spacer(),
                  Container(
                      height: 48,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            isDeleting = true;
                          });
                          try {
                            await Provider.of<MechanicProvider>(context,
                                    listen: false)
                                .deleteService(widget.service.id!, id!);
                            setState(() {
                              isDeleting = false;
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Service Deleted'),
                                backgroundColor: kPrimaryColor,
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              isDeleting = false;
                            });
                          }
                        },
                        color: Colors.red,
                        child: isDeleting
                            ? const MyLoader()
                            : const Text(
                                'Delete Service',
                                style: TextStyle(color: Colors.white),
                              ),
                      )),
                  Container(
                      height: 48,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await Provider.of<MechanicProvider>(context,
                                    listen: false)
                                .editService(
                                    ServiceModel(
                                      id: widget.service.id,
                                      imageFile: imageFile,
                                      imageUrl: widget.service.imageUrl,
                                      price: price ?? widget.service.price,
                                      serviceName:
                                          name ?? widget.service.serviceName,
                                    ),
                                    id!,
                                    widget.service);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Service edited'),
                                backgroundColor: kPrimaryColor,
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        color: kPrimaryColor,
                        child: isLoading
                            ? const MyLoader()
                            : const Text(
                                'Save Changes',
                                style: TextStyle(color: Colors.white),
                              ),
                      ))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openImagePicker(
    BuildContext context,
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

                        imageFile = mediaList.first.file;
                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount: MediaCount.single,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeButtonStyle: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white),
                          ),
                        ),
                        completeText: 'Change',
                        completeTextStyle: const TextStyle(color: Colors.white),
                      ),
                    )),
              ));
        });
  }
}
