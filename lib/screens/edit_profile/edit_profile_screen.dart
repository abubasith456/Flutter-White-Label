import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
          backgroundColor: const Color(0xFFF8FAFC),
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
            horizontal: size.width * 0.04,
            vertical: size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(size),
                SizedBox(height: size.height * 0.03),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Column(
        children: [
          _buildProfileImage(size),
          SizedBox(height: size.height * 0.025),
          Text(
            "Edit Your Profile",
            style: TextStyle(
              fontSize: min(size.width * 0.07, 28),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            "Keep your information up to date",
            style: TextStyle(
              fontSize: min(size.width * 0.04, 16),
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(Size size) {
    final double imageSize = min(size.width * 0.32, 130);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.1),
            const Color(0xFF8B5CF6).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: imageSize * 0.5,
              backgroundColor: const Color(0xFFF1F5F9),
              backgroundImage: _getProfileImage(),
              child: _buildProfileImagePlaceholder(imageSize),
            ),
          ),
          _buildCameraButton(imageSize),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (profilePicUrl.isEmpty) return null;

    if (kIsWeb) {
      // For web, treat all paths as network URLs or data URLs
      return NetworkImage(profilePicUrl);
    } else {
      // For mobile/desktop
      return profilePicUrl.startsWith('http')
          ? NetworkImage(profilePicUrl)
          : FileImage(File(profilePicUrl)) as ImageProvider;
    }
  }

  Widget? _buildProfileImagePlaceholder(double imageSize) {
    return profilePicUrl.isEmpty
        ? Icon(
          Icons.person_outline,
          size: imageSize * 0.45,
          color: const Color(0xFF94A3B8),
        )
        : null;
  }

  Widget _buildCameraButton(double imageSize) {
    return Positioned(
      bottom: 4,
      right: 4,
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: imageSize * 0.18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, Size size) {
    return Container(
      width: min(size.width * 0.92, 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(size.width * 0.06),
      child: Column(
        children: [
          _buildInputField(
            _nameController,
            "Full Name",
            Icons.person_outline,
            size,
          ),
          _buildInputField(
            _emailController,
            "Email Address",
            Icons.email_outlined,
            size,
            enabled: false,
          ),
          _buildDateField(context, size),
          _buildInputField(
            _mobileController,
            "Mobile Number",
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
      padding: EdgeInsets.only(bottom: size.height * 0.024),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        style: TextStyle(
          fontSize: min(size.width * 0.04, 16),
          color: const Color(0xFF1E293B),
          fontWeight: FontWeight.w500,
        ),
        decoration: _getInputDecoration(
          'Date of Birth',
          Icons.calendar_today_outlined,
          size,
          true,
        ),
        validator: (value) => _validateField(value, 'Date of Birth'),
        onTap: () => _showDatePicker(),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime initialDate =
        DateTime.tryParse(_dobController.text) ?? DateTime.now();

    if (Platform.isIOS) {
      await _showCupertinoDatePicker(initialDate);
    } else {
      await _showMaterialDatePicker(initialDate);
    }
  }

  Future<void> _showCupertinoDatePicker(DateTime initialDate) async {
    DateTime? pickedDate;

    await showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            height: 250,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoButton(
                        child: const Text('Done'),
                        onPressed: () {
                          if (pickedDate != null) {
                            setState(() {
                              _dobController.text = DateFormat(
                                'yyyy-MM-dd',
                              ).format(pickedDate!);
                            });
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    maximumDate: DateTime.now(),
                    minimumDate: DateTime(1900),
                    onDateTimeChanged: (date) => pickedDate = date,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _showMaterialDatePicker(DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
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
      padding: EdgeInsets.only(bottom: size.height * 0.024),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: inputType,
        style: TextStyle(
          fontSize: min(size.width * 0.04, 16),
          color: enabled ? const Color(0xFF1E293B) : const Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
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
        fontSize: min(size.width * 0.035, 14),
        color: const Color(0xFF64748B),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
          size: min(size.width * 0.055, 22),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      filled: true,
      fillColor: enabled ? const Color(0xFFFAFBFC) : const Color(0xFFF1F5F9),
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.022,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  String? _validateField(String? value, String label) {
    if (value?.isEmpty ?? true) {
      return "$label cannot be empty";
    }
    if (label == "Mobile Number" && !RegExp(r"^\d{10}$").hasMatch(value!)) {
      return "Please enter a valid 10-digit mobile number";
    }
    return null;
  }

  Widget _buildSaveButton(ProfileState state, Size size) {
    return Container(
      width: min(size.width * 0.92, 500),
      height: size.height * 0.065,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: state is ProfileLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
            strokeWidth: 2.5,
          ),
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_outlined,
              color: Colors.white,
              size: min(size.width * 0.05, 20),
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              "Save Changes",
              style: TextStyle(
                color: Colors.white,
                fontSize: min(size.width * 0.045, 18),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
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
    if (kIsWeb) {
      // For web, only gallery is available
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => profilePicUrl = pickedFile.path);
      }
    } else {
      // For mobile/desktop, show source selection
      final source = await _showImageSourceDialog();
      if (source != null) {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          setState(() => profilePicUrl = pickedFile.path);
        }
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    if (Platform.isIOS) {
      return await showCupertinoModalPopup<ImageSource>(
        context: context,
        builder:
            (context) => CupertinoActionSheet(
              title: const Text('Select Image Source'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                  child: const Text('Camera'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
      );
    } else {
      return await showModalBottomSheet<ImageSource>(
        context: context,
        builder:
            (context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ),
      );
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
