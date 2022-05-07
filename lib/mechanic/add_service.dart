import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/service_tile_shimmer.dart';
import 'package:mechanic_admin/mechanic/service_tile.dart';
import 'package:mechanic_admin/models/service_model.dart';
import 'package:mechanic_admin/providers/mechanic_provider.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

import 'package:provider/provider.dart';

class AddServices extends StatefulWidget {
  final Function(List<ServiceModel> services)? onCompleted;
  const AddServices({Key? key, this.onCompleted, this.isDashboard = false})
      : super(key: key);
  final bool isDashboard;

  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final _formKey = GlobalKey<FormState>();
  List<ServiceModel> services = [];
  int servicesLength = 1;
  List<Media> mediaList = [];
  File? image;
  String? name;
  String? price;
  final priceController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Service(s)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: kPrimaryColor,
        // automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: const Text(
                'Preview',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            ...List.generate(
              services.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Stack(
                  children: [
                    ServiceTile(
                      services[index],
                      isFile: true,
                    ),
                    Positioned(
                        right: 10,
                        top: 5,
                        child: GestureDetector(
                            onTap: () {
                              services.removeAt(index);
                              setState(() {});
                            },
                            child: const Icon(Icons.close)))
                  ],
                ),
              ),
            ),
            if (services.isEmpty)
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: const ServiceTileShimmer()),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: const Text(
                'Add Services/Offers',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              openImagePicker(context);
                            },
                            child: Container(
                              height: 70,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add),
                                  Text(
                                    'Add Image',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (image != null)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 70,
                              width: 80,
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            )
                        ],
                      ),
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        child: TextFormField(
                            controller: nameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter the name of the service';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText: 'Name of service',
                                helperStyle:
                                    const TextStyle(color: kPrimaryColor),
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        child: TextFormField(
                            controller: priceController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter the price of the service';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText: 'Price',
                                helperStyle:
                                    const TextStyle(color: kPrimaryColor),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: kPrimaryColor, width: 1)),
                                border: InputBorder.none),
                            onEditingComplete: () {
                              services.add(ServiceModel(
                                imageFile: image,
                                serviceName: name,
                                price: price,
                              ));
                            },
                            onChanged: (text) => {
                                  setState(() {
                                    price = text;
                                  })
                                }),
                      ),
                      const Divider(
                        color: Colors.black,
                      )
                    ])),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 45,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    services.add(ServiceModel(
                        price: price, imageFile: image, serviceName: name));
                    price = null;
                    image = null;
                    name = null;
                    priceController.clear();
                    nameController.clear();
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: kPrimaryColor,
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              height: 45,
              child: RaisedButton(
                onPressed: services.isEmpty
                    ? null
                    : () async {
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        if (widget.isDashboard) {
                          await Provider.of<MechanicProvider>(context,
                                  listen: false)
                              .addService(services, uid);
                        } else {
                          widget.onCompleted!(services);
                        }
                        Navigator.of(context).pop();
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: kPrimaryColor,
                child: Text(
                  widget.isDashboard ? 'Save' : 'Complete',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
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

                        image = mediaList.first.file;
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
                            TextStyle(color: Colors.white),
                          ),
                        ),
                        completeText: 'Change',
                        completeTextStyle: TextStyle(color: Colors.white),
                      ),
                    )),
              ));
        });
  }
}
