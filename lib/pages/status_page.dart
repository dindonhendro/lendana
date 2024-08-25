import 'package:flutter/material.dart';
import 'package:lendana5/components/my_timeline.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MyTimeline(
            isFirst: true,
            isLast: false,
            isPast: true,
            eventContent: Text('Isi Data Diri dan Dokumen '),
          ),
          MyTimeline(
            isFirst: true,
            isLast: false,
            isPast: false,
            eventContent: Text('Proses Pendaftaran'),
          ),
          MyTimeline(
            isFirst: true,
            isLast: false,
            isPast: false,
            eventContent: Text('Proses Bank'),
          ),
          MyTimeline(
            isFirst: false,
            isLast: true,
            isPast: true,
            eventContent: Text('Approved'),
          ),
        ],
      ),
    );
  }
}
