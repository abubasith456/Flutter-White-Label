import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _mobileController;
  String profilePicUrl = "";
  String userId = ""; // Store userId here

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _nameController = TextEditingController(text: profileState.user.name);
      _emailController = TextEditingController(text: profileState.user.email);
      _dobController = TextEditingController(text: profileState.user.dob);
      _mobileController = TextEditingController(text: profileState.user.mobile);
      profilePicUrl =
          profileState.user.profilePic.isNotEmpty
              ? profileState.user.profilePic
              : "";
      userId = profileState.user.id; // Assign userId here
      print("Profile: $profilePicUrl");
    }
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        profilePicUrl = pickedFile.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfile(
          userId: userId, // Pass the userId here
          username: _nameController.text,
          email: _emailController.text,
          dob: _dobController.text,
          mobile: _mobileController.text,
          profilePicUrl: profilePicUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: "Edit Profile"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            profilePicUrl.isNotEmpty
                                ? (profilePicUrl.startsWith('http')
                                    ? NetworkImage(profilePicUrl)
                                        as ImageProvider
                                    : FileImage(File(profilePicUrl)))
                                : null,
                        child:
                            profilePicUrl.isEmpty
                                ? const Icon(Icons.camera_alt, size: 50)
                                : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_nameController, "Name"),
                    _buildTextField(_emailController, "Email"),
                    _buildTextField(_dobController, "Date of Birth"),
                    _buildTextField(
                      _mobileController,
                      "Mobile",
                      inputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        state is ProfileLoading ? "Saving..." : "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? inputType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "$label cannot be empty";
          } else if (label == "Email" &&
              !RegExp(
                r"^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$",
              ).hasMatch(value)) {
            return "Please enter a valid email";
          } else if (label == "Mobile" &&
              !RegExp(r"^\d{10}$").hasMatch(value)) {
            return "Please enter a valid 10-digit mobile number";
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}
