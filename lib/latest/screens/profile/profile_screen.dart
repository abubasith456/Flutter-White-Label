import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/route/screen_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.white],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                context.read<ProfileBloc>().add(LoadProfile());
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return Column(
                  children: [
                    _buildProfileHeader(state.username, state.profilePicUrl),
                    Expanded(child: _buildOptionsList(context)),
                    // _buildLogoutButton(context), // Bottom logout button
                  ],
                );
              } else {
                return const Center(child: Text("Failed to load profile"));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String username, String profilePicUrl) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              profilePicUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            username,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'View and edit your profile details',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildOptionItem(Icons.edit, "Edit Profile", () {
            Navigator.pushNamed(context, editProfileScreenRoute);
          }),
          _buildOptionItem(Icons.location_on, "Address", () {
            Navigator.pushNamed(context, addressScreenRouter);
          }),
          _buildOptionItem(Icons.history, "Order History", () {
            Navigator.pushNamed(context, orderHistoryScreenRoute);
          }),
          _buildOptionItem(Icons.notifications, "Notifications", () {
            Navigator.pushNamed(context, notificationScreenRoute);
          }),
          _buildOptionItem(Icons.logout, "Logout", () {
            context.read<ProfileBloc>().add(Logout());
          }),
        ],
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: MediaQuery.of(context).padding.bottom + 30,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            context.read<ProfileBloc>().add(Logout());
          },
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
