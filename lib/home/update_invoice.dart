import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic_admin/models/request_model.dart';
import 'package:mechanic_admin/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class UpdateInvoice extends StatefulWidget {
  const UpdateInvoice({Key? key, required this.request}) : super(key: key);
  final RequestModel request;

  @override
  State<UpdateInvoice> createState() => _UpdateInvoiceState();
}

class _UpdateInvoiceState extends State<UpdateInvoice> {
  String? amount;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text(
                'Update Payment',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: Lottie.asset('assets/pay.json'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Are you sure you want to update this payment?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    amount = val;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await Provider.of<PaymentProvider>(context,
                                listen: false)
                            .updatePayment(widget.request, amount!);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
