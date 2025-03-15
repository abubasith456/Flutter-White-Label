import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/route/screen_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              context.read<ProfileBloc>().add(LoadProfile());
              // Navigate to Login screen after logout
              // Navigator.pushReplacementNamed(context, "/login");
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return Column(
                children: [
                  _buildProfileHeader(state.username, state.profilePicUrl),
                  Expanded(child: _buildOptionsList(context)),
                  _buildLogoutButton(context),
                ],
              );
            } else {
              return Center(child: Text("Failed to load profile"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String username, String profilePicUrl) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profilePicUrl),
          ),
          SizedBox(height: 10),
          Text(
            username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10), // Added margins
      child: Column(
        children: [
          _buildOptionItem(Icons.edit, "Edit Profile", () {
            Navigator.pushNamed(context, editProfileScreenRoute);
          }),
          _buildOptionItem(Icons.location_on, "Address", () {}),
          _buildOptionItem(Icons.history, "Order History", () {}),
          _buildOptionItem(Icons.notifications, "Notifications", () {}),
        ],
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 150,
        right: 150,
        bottom: MediaQuery.of(context).padding.bottom + 100,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            context.read<ProfileBloc>().add(Logout());
          },
          child: Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
