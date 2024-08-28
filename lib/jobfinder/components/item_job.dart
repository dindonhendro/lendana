import 'package:flutter/material.dart';
import 'package:lendana5/jobfinder/models/job.dart';
import 'package:lendana5/jobfinder/screens/job_detail_screen.dart';

class ItemJob extends StatelessWidget {
  final Job job;
  final bool themeDark;

  ItemJob(this.job, {this.themeDark = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, bottom: 20.0, top: 20.0),
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
          color: themeDark ? Theme.of(context).primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        job.company.assetLogo ?? 'assets/default_logo.png',
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            job.company.name,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: themeDark
                                  ? Color(0xFFB7B7D2)
                                  : Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            job.role,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: themeDark ? Colors.white : Colors.black,
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
                                    color: themeDark
                                        ? Color(0xFFB7B7D2)
                                        : Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      job.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: themeDark ? Colors.white : Colors.grey,
                      size: 20.0,
                    ),
                    onPressed: () {
                      // Implement the favorite toggle logic here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
