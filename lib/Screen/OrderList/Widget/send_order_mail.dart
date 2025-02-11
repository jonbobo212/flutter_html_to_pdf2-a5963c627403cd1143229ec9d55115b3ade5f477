import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/EmailSend/email.dart';
import 'package:sellermultivendor/Screen/MediaUpload/Media.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/mail/send_mail_cubit.dart';

class SendOrderMailScreen extends StatefulWidget {
  final OrderModel order;
  final OrderItem item;
  const SendOrderMailScreen(
      {super.key, required this.order, required this.item});

  @override
  State<SendOrderMailScreen> createState() => _SendOrderMailScreenState();
}

class _SendOrderMailScreenState extends State<SendOrderMailScreen> {
  late final TextEditingController _emailController =
      TextEditingController(text: widget.order.email!);
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    selectedUploadFileSubDic = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendMailCubit, SendMailState>(
      listener: (context, state) {
        if (state is SendMailSuccess) {
          setSnackbar('SEND_SUCCESS'.translate(context), context,
              backgroundColor: Colors.green);
          Navigator.pop(context);
        }
        if (state is SendMailFail) {
          setSnackbar("somethingMSg".translate(context), context,
              backgroundColor: const Color.fromARGB(255, 255, 129, 129));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: Text('send_email'.translate(context)),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildField(
                    context,
                    controller: _emailController,
                    title: 'Email'.translate(context),
                    hintText: 'Email'.translate(context),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildField(
                    context,
                    controller: _subjectController,
                    title: 'Subject'.translate(context),
                    hintText: ''.translate(context),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildField(context,
                      controller: _emailTextController,
                      title: 'Message'.translate(context),
                      hintText: 'Write something...'.translate(context),
                      linesNoLimit: true),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text('File: '),
                      Text(selectedUploadFileSubDic),
                      const Spacer(),
                      MaterialButton(
                          color: primary.withOpacity(0.7),
                          elevation: 0,
                          textColor: white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Media(
                                    from: "archive,document",
                                    pos: 0,
                                    type: "email",
                                  ),
                                ));

                            setState(() {});
                          },
                          minWidth: 50,
                          child: const Icon(Icons.add)),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  BlocBuilder<SendMailCubit, SendMailState>(
                    builder: (context, state) {
                      return MaterialButton(
                        color: primary,
                        elevation: 0,
                        textColor: white,
                        height: 42,
                        disabledColor: primary.withOpacity(0.8),
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: state is SendMailInProgress
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedUploadFileSubDic != '') {
                                    context.read<SendMailCubit>().send(
                                        orderID: widget.order.id!,
                                        orderItemId: widget.item.id!,
                                        email: widget.order.email!,
                                        subject: _subjectController.text,
                                        message: _emailTextController.text,
                                        attachment: selectedUploadFileSubDic,
                                        username: widget.order.username!);
                                  } else {
                                    setSnackbar(
                                        'select_file'.translate(context),
                                        context,
                                        backgroundColor: const Color.fromARGB(
                                            255, 255, 129, 129));
                                  }
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state is SendMailInProgress)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: white,
                                      strokeWidth: 1.5,
                                    )),
                              ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text('Send Mail'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(BuildContext context,
      {required String title,
      required TextEditingController controller,
      String? hintText,
      bool? linesNoLimit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'field_required'.translate(context);
            }
            return null;
          },
          maxLines: linesNoLimit == true ? null : 1,
          minLines: linesNoLimit == true ? 5 : null,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: white,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFC9C9C9))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: lightWhite)),
          ),
        )
      ],
    );
  }
}
