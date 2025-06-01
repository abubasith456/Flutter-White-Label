import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:math' show min;

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
  String userId = "";

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _nameController = TextEditingController(text: profileState.user.name);
      _emailController = TextEditingController(text: profileState.user.email);
      _initializeDateController(profileState.user.dob);
      _mobileController = TextEditingController(text: profileState.user.mobile);
      profilePicUrl = profileState.user.profilePic;
      userId = profileState.user.id;
    }
  }

  void _initializeDateController(String dob) {
    try {
      final DateTime date = DateTime.parse(dob);
      _dobController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(date),
      );
    } catch (e) {
      _dobController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: "Edit Profile"),
          body: _buildBody(context, state, size),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(size),
                SizedBox(height: size.height * 0.04),
                _buildForm(context, size),
                SizedBox(height: size.height * 0.04),
                _buildSaveButton(state, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Column(
      children: [
        _buildProfileImage(size),
        SizedBox(height: size.height * 0.02),
        Text(
          "Edit Your Profile",
          style: TextStyle(
            fontSize: min(size.width * 0.06, 24),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "Update your profile information",
          style: TextStyle(
            fontSize: min(size.width * 0.04, 16),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(Size size) {
    final double imageSize = min(size.width * 0.3, 120);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: imageSize * 0.5,
            backgroundColor: Colors.grey[100],
            backgroundImage: _getProfileImage(),
            child: _buildProfileImagePlaceholder(imageSize),
          ),
        ),
        _buildCameraButton(imageSize),
      ],
    );
  }

  ImageProvider? _getProfileImage() {
    if (profilePicUrl.isEmpty) return null;
    return profilePicUrl.startsWith('http')
        ? NetworkImage(profilePicUrl)
        : FileImage(File(profilePicUrl)) as ImageProvider;
  }

  Widget? _buildProfileImagePlaceholder(double imageSize) {
    return profilePicUrl.isEmpty
        ? Icon(Icons.person, size: imageSize * 0.5, color: Colors.blue[300])
        : null;
  }

  Widget _buildCameraButton(double imageSize) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.camera_alt,
            size: imageSize * 0.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, Size size) {
    return Container(
      width: min(size.width * 0.9, 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        children: [
          _buildInputField(_nameController, "Name", Icons.person_outline, size),
          _buildInputField(
            _emailController,
            "Email",
            Icons.email_outlined,
            size,
            enabled: false,
          ),
          _buildDateField(context, size),
          _buildInputField(
            _mobileController,
            "Mobile",
            Icons.phone_outlined,
            size,
            inputType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        style: TextStyle(fontSize: min(size.width * 0.04, 16)),
        decoration: _getInputDecoration(
          'Date of Birth',
          Icons.calendar_today,
          size,
          true,
        ),
        validator: (value) => _validateField(value, 'Date of Birth'),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate:
                DateTime.tryParse(_dobController.text) ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.blue[600]!,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                  dialogBackgroundColor: Colors.white,
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue[600],
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            setState(() {
              _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
            });
          }
        },
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon,
    Size size, {
    bool enabled = true,
    TextInputType? inputType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: inputType,
        style: TextStyle(fontSize: min(size.width * 0.04, 16)),
        decoration: _getInputDecoration(label, icon, size, enabled),
        validator: (value) => _validateField(value, label),
      ),
    );
  }

  InputDecoration _getInputDecoration(
    String label,
    IconData icon,
    Size size,
    bool enabled,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: min(size.width * 0.04, 16),
        color: Colors.grey[600],
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.blue,
        size: min(size.width * 0.06, 24),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      filled: !enabled,
      fillColor: enabled ? null : Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
    );
  }

  String? _validateField(String? value, String label) {
    if (value?.isEmpty ?? true) {
      return "$label cannot be empty";
    }
    if (label == "Mobile" && !RegExp(r"^\d{10}$").hasMatch(value!)) {
      return "Please enter a valid 10-digit mobile number";
    }
    return null;
  }

  Widget _buildSaveButton(ProfileState state, Size size) {
    return Container(
      width: min(size.width * 0.9, 500),
      height: size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: state is ProfileLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildSaveButtonChild(state, size),
      ),
    );
  }

  Widget _buildSaveButtonChild(ProfileState state, Size size) {
    return state is ProfileLoading
        ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
        : Text(
          "Save Changes",
          style: TextStyle(
            color: Colors.white,
            fontSize: min(size.width * 0.045, 18),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        );
  }

  void _handleStateChanges(BuildContext context, ProfileState state) {
    if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    } else if (state is ProfileLoaded) {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => profilePicUrl = pickedFile.path);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      try {
        final DateTime dob = DateFormat(
          'yyyy-MM-dd',
        ).parse(_dobController.text);
        context.read<ProfileBloc>().add(
          UpdateProfile(
            userId: userId,
            username: _nameController.text,
            email: _emailController.text,
            dob: dob.toIso8601String(),
            mobile: _mobileController.text,
            profilePicUrl: profilePicUrl,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid date format'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
