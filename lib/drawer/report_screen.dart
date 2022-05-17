import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/my_loader.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/admin_user_provider.dart';
import 'package:mechanic_admin/providers/mechanic_provider.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, required this.request}) : super(key: key);
  final RequestModel request;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? message;

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
        ),
        title: const Text("Report A Mechanic",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    message = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter your message";
                  }
                  return null;
                },
                maxLength: null,
                maxLines: null,
                style: const TextStyle(
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: const TextStyle(
                    letterSpacing: 0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 22,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: isLoading
                  ? const MyLoader()
                  : const Text('Submit',
                      style: TextStyle(
                        color: Colors.white,
                      )),
              color: kPrimaryColor,
              onPressed: message == null
                  ? () {}
                  : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        final statusCode =
                            await sendReport(widget.request, message!);
                        setState(() {
                          isLoading = false;
                        });

                        if (statusCode == 200) {
                          await Provider.of<AdminUserProvider>(context,
                                  listen: false)
                              .reportUser(widget.request);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                      'You have successfully reported this user',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'Something went wrong, please try again later',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ));
                        }
                      }
                    },
            )
          ],
        ),
      ),
    );
  }
}

Future sendReport(RequestModel request, String message) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_9rpw7w8';
  const templateId = 'template_z45sr5m';
  const userId = 'VuUlTtlEpMwxt0xwT';
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'name': request.user!.fullName!,
          'mech': request.mechanic!.id!,
          'message': message,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'request': request.id!,
          'phone': request.user!.phoneNumber!,
          'email': request.user!.email!,
        }
      }));
  print(response.body);

  return response.statusCode;
}
