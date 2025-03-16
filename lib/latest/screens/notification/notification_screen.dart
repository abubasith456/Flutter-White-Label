import 'package:demo_app/latest/screens/notification/components/bloc/notitifaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications"), centerTitle: true),
      body: BlocProvider(
        create: (_) => NotificationBloc()..add(LoadNotifications()),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.notifications, color: Colors.blue),
                      title: Text(state.notifications[index]),
                    ),
                  );
                },
              );
            } else if (state is NotificationEmpty) {
              return Center(child: Text("No new notifications"));
            } else {
              return Center(child: Text("Failed to load notifications"));
            }
          },
        ),
      ),
    );
  }
}
