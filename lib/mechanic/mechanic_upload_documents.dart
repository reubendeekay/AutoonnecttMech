import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/constants.dart';

class MechanicUploadDocuments extends StatefulWidget {
  const MechanicUploadDocuments({Key? key, required this.onUpload})
      : super(key: key);
  final Function(File id, File permit)? onUpload;

  @override
  State<MechanicUploadDocuments> createState() =>
      _MechanicUploadDocumentsState();
}

class _MechanicUploadDocumentsState extends State<MechanicUploadDocuments> {
  File? nationalId;
  File? permit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Documents',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                setState(() {
                  nationalId = File(result.files.single.path!);
                });
              } else {
                // User canceled the picker
              }
            },
            title: const Text('National ID/Passport'),
            subtitle: const Text('Upload your National ID/Passport'),
            trailing: Icon(
              Icons.check_circle,
              color: nationalId != null ? Colors.green : Colors.grey,
            ),
          ),
          ListTile(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                setState(() {
                  permit = File(result.files.single.path!);
                });
              } else {
                // User canceled the picker
              }
            },
            title: const Text('Permit'),
            subtitle: const Text('Upload your Permit'),
            trailing: Icon(Icons.check_circle,
                color: permit != null ? Colors.green : Colors.grey),
          ),
          const Spacer(),
          Container(
            height: 48,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton(
              onPressed: nationalId == null || permit == null
                  ? null
                  : () {
                      setState(() {
                        widget.onUpload?.call(nationalId!, permit!);
                      });
                      Navigator.of(context).pop();
                    },
              child: const Text(
                'Complete',
                style: TextStyle(color: Colors.white),
              ),
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
