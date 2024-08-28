import 'package:flutter/material.dart';
import 'package:lendana5/jobfinder/models/job.dart';
import 'package:lendana5/pages/bank_page.dart';
import 'package:lendana5/repository/api_repository.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  JobDetailScreen({required this.job});

  final Future<int?> userIdFuture = ApiRepository().getId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.role),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              job.company.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Location: ${job.location}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              job.detail,
              style: TextStyle(fontSize: 14.0),
            ),
            Spacer(),
            // Use FutureBuilder to wait for the userId
            FutureBuilder<int?>(
              future: userIdFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the userId is being fetched, show a loading indicator
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there was an error fetching the userId, show an error message
                  return Text('Error fetching user ID');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  // If no userId is returned, show an error message
                  return Text('User ID not found');
                } else {
                  // Once the userId is fetched, show the button
                  return ElevatedButton(
                    onPressed: () {
                      // Navigate to the BankPage when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BankPage(userId: snapshot.data!),
                        ),
                      );
                    },
                    child: Text('Ajukan Pinjaman'),
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(double.infinity, 50), // Full width button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
