import 'dart:convert'; // For json decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lendana5/constants.dart';
import 'package:lendana5/jobfinder/components/my_drawer.dart';
import 'package:lendana5/jobfinder/models/job.dart';
import 'package:lendana5/jobfinder/models/company.dart';
import 'package:lendana5/jobfinder/screens/job_detail_screen.dart'; // Import the detail screen

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Job> allJobs = [];
  List<Job> filteredJobs = [];
  List<String> locations = [];
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    fetchJobs(); // Fetch jobs when the screen is initialized
  }

  Future<void> fetchJobs() async {
    final response = await http.get(Uri.parse('$BASE_URLP/api/jobs'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final jobsData = jsonResponse['data'];

      setState(() {
        allJobs = jobsData.map<Job>((jobData) {
          return Job(
            role: jobData['role'] ?? 'Unknown Role',
            location: jobData['location'] ?? 'Unknown Location',
            detail: jobData['detail'] ?? 'No details available',
            isFavorite: jobData['isFavorite'] ?? false,
            company: Company(
              name: jobData['company'] ?? 'Unknown Company',
              urlLogo:
                  '', // There is no 'logo' field in the response, so leave it empty
            ),
          );
        }).toList();

        // Extract unique locations
        locations = allJobs.map((job) => job.location).toSet().toList();

        // Initially show all jobs
        filteredJobs = List.from(allJobs);
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  void filterJobsByLocation(String? location) {
    setState(() {
      selectedLocation = location;
      filteredJobs = location == null || location.isEmpty
          ? List.from(allJobs)
          : allJobs.where((job) => job.location == location).toList();
    });
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

  Widget buildJobCard(Job job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: job),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.role,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        job.company.name,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Image.asset(
                    getFlagImage(job.location), // Display the flag image
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Location: ${job.location}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                job.detail,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(''),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _customAppBar(),
            _locationFilter(),
            _textsHeader(context),
            _jobList(context),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget _customAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Add your custom icons here if needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: DropdownButton<String>(
        value: selectedLocation,
        hint: Text('Select Country'),
        items: locations.map((location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(location),
          );
        }).toList(),
        onChanged: (value) {
          filterJobsByLocation(value);
        },
      ),
    );
  }

  Widget _textsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Find Your Dream Job',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Search for your dream job in different countries',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _jobList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: filteredJobs.map((job) => buildJobCard(job)).toList(),
      ),
    );
  }
}
