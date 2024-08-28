import 'package:lendana5/jobfinder/models/job.dart';
import 'package:flutter/material.dart';
import 'package:lendana5/jobfinder/screens/job_detail_screen.dart';

class CompactItemJob extends StatelessWidget {
  final Job job;

  CompactItemJob(this.job);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      child: InkWell(
        onTap: () {
          // Navigate to the job detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(job: job),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 3,
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                job.company.assetLogo ?? 'assets/default_logo.png',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              job.company.name,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[800],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 4.0),
                Text(
                  job.role,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).highlightColor,
                      size: 14.0,
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        job.location,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.favorite_border,
              color: Theme.of(context).highlightColor,
            ),
          ),
        ),
      ),
    );
  }
}
