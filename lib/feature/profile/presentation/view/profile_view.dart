import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_events.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_state.dart';

import '../../../../core/utils/go_to_settings_dialog.dart';
import '../../../../core/utils/manage_camera_permission.dart';
import '../../../../core/utils/manage_photos_permission.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.profile),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        userNameController.text = state.userName;
        emailController.text = state.email;
        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedImage =
                          await showCameraGalleryBottomSheet(context);
                      // ImagePicker()
                      //     .pickImage(source: ImageSource.camera)
                      //     .then((value) {
                      if (pickedImage != null) {
                        context.read<ProfileBloc>().add(
                              ProfileImageSelected(
                                image: pickedImage ?? "",
                              ),
                            );
                      }
                    },
                    child: Stack(
                      children: [
                        state.image == ""
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(state.image),
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(label: Text("User Name")),
                    onChanged: (value) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileNameChanged(name: value));
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileNameUpdated(name: state.userName));
                      Fluttertoast.showToast(msg: "User name updated.");
                    },
                    child: Text(
                      "Update Name",
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(label: Text("Email")),
                    onChanged: (value) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileEmailChanged(email: value));
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileEmailUpdated(email: state.email));
                      Fluttertoast.showToast(msg: "User email updated.");
                    },
                    child: Text(
                      "Update Email",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

Future<dynamic> showCameraGalleryBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8C92AC),
                  ),
                  onPressed: () async {
                    try {
                      await manageCameraPermissions(
                          onGrantedCallback: () async {
                            var pickedImage = await ImagePicker()
                                .pickImage(source: ImageSource.camera);

                            if (pickedImage != null) {
                              context.pop(pickedImage.path);
                              // myProfileController.editProfileState.selectedImage
                              //     .value = croppedImage.path;
                              // myProfileController.editProfileState.isPicture =
                              //     true;
                            }

                            // context.pop();
                          },
                          onDeniedCallback: () {},
                          onPermanentlyDeniedCallback: () async {
                            await goToSettings(
                              context: context,
                              title: "Permission Required",
                              content:
                                  "Please allow camera permission to upload profile picture.",
                              buttonTitle: "Open App Settings",
                            );
                          });
                    } on PlatformException catch (e) {
                      Fluttertoast.showToast(msg: "Failed to pick image");
                    }
                  },
                  child: Text(
                    "From Camera",
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8C92AC),
                  ),
                  onPressed: () async {
                    if (Platform.isIOS) {
                      try {
                        await managePhotosPermission(
                            onGrantedCallback: () async {
                              var pickedImage = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (pickedImage != null) {
                                context.pop(pickedImage.path);
                              }

                              // context.pop();
                            },
                            onDeniedCallback: () {},
                            onPermanentlyDeniedCallback: () async {
                              await goToSettings(
                                context: context,
                                title: "Permission Required",
                                content:
                                    "Please allow photos permission to upload profile picture.",
                                buttonTitle: "Open App Settings",
                              );
                            });
                      } on PlatformException catch (e) {
                        print('Failed to pick image from gallery: $e');
                      }
                    } else {
                      var pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedImage != null) {
                        context.pop(pickedImage.path);
                      }
                    }
                  },
                  child: const Text(
                    "From Gallery",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        );
      });
}
