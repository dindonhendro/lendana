import 'package:flutter/material.dart';
import 'package:lendana5/components/my_drawer.dart';

import 'package:lendana5/jobfinder/models/job.dart';
import 'package:lendana5/jobfinder/models/company.dart';
import '../components/job_carousel.dart';
import '../components/job_list.dart';

class MainScreen extends StatelessWidget {
  final List<Job> forYouJobs = [
    Job(
      role: 'Automotive Engineer',
      location: 'Okinawa Japan',
      detail: '''Perbaikan dan Pemeliharaan Mobil (Jidousha Seibi)

Isi pekerjaan bidang ini berupa inspeksi dan pemeliharaan harian, pemeriksaan dan pemeliharaan rutin, pembongkaran dan pemeliharaan kendaraan''',
      company: Company(
        name: 'Impex Japan Workshop',
        assetLogo: 'assets/logos/auto.png',
      ),
    ),
    Job(
      role: 'AgriCulture Supervisor',
      location: 'Obihiro Japan',
      detail: '''Agrikultur (Nougyou)
Isi pekerjaan bidang ini berupa pertanian tanaman umum (manajemen kultivasi, panen, pengiriman dan pemilihan produk pertanian, dll.), peternakan hewan (manajemen pakan ternak, panen, pengiriman dan pemilihan produk peternakan, dll.)''',
      company: Company(
        name: 'Obihiro Farm',
        assetLogo: 'assets/logos/agri.png',
      ),
    ),
    Job(
      role: 'Building Cleaner',
      location: 'Shibuya Japan',
      detail: '''Manajemen Kebersihan Gedung (Biru Kuriningu)
Isi pekerjaan bidang ini adalah pembersihan bagian dalam bangunan umum (kecuali tempat tinggal), seperti menghilangkan noda/kotoran, menjaga kebersihan lingkungan dan sebagainya      ''',
      company: Company(
        name: 'Shibuya Building Cleaning',
        assetLogo: 'assets/logos/cleaning.png',
      ),
    ),
  ];

  final List<Job> recentJobs = [
    Job(
      role: 'Restaurant Manager',
      location: 'Osaka, Japan',
      detail:
          '''Isi pekerjaan bidang ini berupa pekerjaan industri restoran secara umum (menyiapkan makanan, pelayanan pelanggan, manajemen restoran)''',
      company: Company(
        name: 'Osaka Grill Resto',
        assetLogo: 'assets/logos/resto.png',
      ),
    ),
    Job(
      role: 'Perawat Lansia',
      location: 'Tokyo, Japan',
      detail:
          '''Isi pekerjaannya berupa perawatan fisik untuk lansia seperti memandikan, membantu saat makan atau buang air, serta menjaga mental dan fisik lansia yang diurus. Terdapat juga layanan bantuan tambahan seperti membantu jalan-jalan, berolahraga,
Kunjungan ke rumah pasien (home visit) tidak termasuk ke dalam bidang ini''',
      company: Company(
        name: 'Tokyo Hospital',
        assetLogo: 'assets/logos/nurse.png',
      ),
    ),
    Job(
      role: 'Supervisor',
      location: 'Kyoto, Japan',
      detail:
          '''Isi pekerjaan bidang ini berupa manufaktur pembuatan makanan dan minuman secara umum (pembuatan dan pemrosesan makanan dan minuman, manajemen kesehatan dan keamanan. 
''',
      company: Company(
        name: 'Kyoto Food',
        assetLogo: 'assets/logos/food.png',
      ),
    ),
    Job(
      role: 'Perawat Lansia',
      location: 'Tokyo, Japan',
      detail:
          '''Isi pekerjaannya berupa perawatan fisik untuk lansia seperti memandikan, membantu saat makan atau buang air, serta menjaga mental dan fisik lansia yang diurus. Terdapat juga layanan bantuan tambahan seperti membantu jalan-jalan, berolahraga,
Kunjungan ke rumah pasien (home visit) tidak termasuk ke dalam bidang ini''',
      company: Company(
        name: 'Tokyo Hospital',
        assetLogo: 'assets/logos/nurse.png',
      ),
    ),
    Job(
      role: 'Hotel Manager',
      location: 'Kyoto, Japan',
      detail: '''Hotel atau Industri Akomodasi (Shukuhaku)
Isi pekerjaan bidang ini berupa penyediaan servis akomodasi seperti front desk penginapan, perencanaan/relasi publik, hospitality, service restoran.
''',
      company: Company(
        name: 'Kyoto Hotel Chain',
        assetLogo: 'assets/logos/hotel.png',
      ),
    ),
    Job(
      role: 'Fish Engineer',
      location: 'Okinawa Japan',
      detail: '''Perikanan dan Akuakultur (Gyogyou)
Isi pekerjaan bidang ini berupa perikanan (memproduksi dan memperbaiki peralatan penangkapan ikan, eksplorasi hewan dan tumbuhan laut, pengoperasian peralatan dan mesin penangkapan ikan, panen hewan atau tumbuhan laut, perawatan dan penyimpanan produk perikanan, pemastian keamanan dan kesehatan, dll.), industri Aquaculture (produksi, perbaikan dan manajemen material perikanan, manajemen kultivasi hewan dan tumbuhan laut, panen dan pemrosesan, pemastian keamanan dan kesehatan

''',
      company: Company(
        name: 'Hoka Fishery',
        assetLogo: 'assets/logos/resto.png',
      ),
    )
  ];

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
            _textsHeader(context),
            _forYou(context),
            _recent(context),
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
          // IconButton(
          //   iconSize: 40.0,
          //   icon: SvgPicture.asset('assets/icons/slider.svg'),
          //   onPressed: () {},
          // ),
          // Wrap this Row with Flexible to ensure it doesn't overflow
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // IconButton(
                //   iconSize: 40.0,
                //   icon: SvgPicture.asset('assets/icons/search.svg'),
                //   onPressed: () {},
                // ),
                // IconButton(
                //   iconSize: 40.0,
                //   icon: SvgPicture.asset('assets/icons/settings.svg'),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],
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
            //  style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 10.0),
          Text(
            'Search for your dream job in different sectors',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _forYou(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'Jobs For You',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          JobCarousel(forYouJobs),
        ],
      ),
    );
  }

  Widget _recent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 5.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Recent Job Available',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // Use Flexible or Expanded if there's a chance of overflow
                Flexible(
                  child: Text(
                    '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: JobList(recentJobs),
          ),
        ],
      ),
    );
  }
}
