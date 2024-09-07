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
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.role,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  getFlagImage(job.location), // Display the flag image
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Company: ${job.company.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Location: ${job.location}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              job.detail,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 50),
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
            )
          ],
        ),
      ),
    );
  }

  // Helper function to get flag image path based on location (country)
  String getFlagImage(String location) {
    switch (location.toLowerCase()) {
      case 'taiwan':
        return 'assets/flags/taiwan.png';
      case 'japan':
        return 'assets/flags/japan.png';
      case 'korea':
        return 'assets/flags/korea.png';
      case 'singapore':
        return 'assets/flags/singapore.png';
      default:
        return 'assets/flags/default.png'; // Default flag if needed
    }
  }
}
