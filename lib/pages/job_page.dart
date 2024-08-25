import 'package:flutter/material.dart';
import 'package:lendana5/components/my_drawer.dart';
import 'package:lendana5/repository/api_repository.dart';

class JobPage extends StatefulWidget {
  final Future<int?> userIdFuture = ApiRepository().getId();

  JobPage({Key? key}) : super(key: key);

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(''),
      ),
      drawer: MyDrawer(),
      body: FutureBuilder<int?>(
        future: widget.userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Center(
                child: Text('User ID: ${snapshot.data}'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
