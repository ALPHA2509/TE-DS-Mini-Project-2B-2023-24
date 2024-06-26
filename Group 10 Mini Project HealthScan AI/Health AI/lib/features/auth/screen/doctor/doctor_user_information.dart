import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthai/colors.dart';
import 'package:healthai/common/enums/user_type_enum.dart';
import 'package:healthai/common/widgets/common_snackbar.dart';
import 'package:healthai/common/widgets/image_picker.dart';
import 'package:healthai/features/auth/controller/auth_controller.dart';

class DoctorUserInformationScreen extends ConsumerStatefulWidget {
  const DoctorUserInformationScreen({super.key});

  static const routeName = '/doctor-user-information';

  @override
  ConsumerState<DoctorUserInformationScreen> createState() =>
      _DoctorUserInformationScreenState();
}

class _DoctorUserInformationScreenState
    extends ConsumerState<DoctorUserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? image;

  void selectImage() async {
    image = await addPhoto(context);
    setState(() {});
  }

  void saveUserDataToFirebase() {
    String name = nameController.text.trim();
    String phoneNumber = phoneController.text.trim();
    String expertise = expertiseController.text.trim();
    String address = addressController.text.trim();

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context: context,
            name: name,
            phoneNumber: phoneNumber,
            expertise: expertise,
            address: address,
            profilePic: image,
            type: UserTypeEnum.doctor,
          );
    } else {
      showsnackbar(context: context, msg: 'enter both fields');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    expertiseController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 64,
                            backgroundColor: blackColor,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 64,
                          ),
                    Positioned(
                      bottom: -10,
                      right: -5,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your phone number',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: expertiseController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your expertise',
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your address',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => saveUserDataToFirebase(),
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
