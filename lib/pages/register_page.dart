import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lendana5/constants.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Controller for confirm password

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  bool _termsAccepted = false;

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_termsAccepted) {
      setState(() {
        _errorMessage = 'You must accept the terms and conditions to proceed.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String url = '$BASE_URLP/api/auth/local/register';
    Map<String, String> userData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage =
              'Error adding user: ${json.decode(response.body)['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Exception occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Dispose confirm password controller
    super.dispose();
  }

  void _showTermsAndConditions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsAndConditionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi Data Diri',
            style: TextStyle(color: Colors.black, fontSize: 15)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/lendana.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Anda Telah Membaca dan Menyetujui ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _showTermsAndConditions,
                          ),
                        ],
                      ),
                    ),
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _addUser,
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Syarat & Ketentuan Pengguna
Last Updated: Agustus 29, 2024

Pada dokumen Syarat dan Ketentuan Penggunaan (“S&K”) ini menyatakan syarat dan ketentuan yang perlu Anda penuhi dan setujui untuk dapat menggunakan aplikasi dan/atau situs yang kami sediakan (“Layanan”) dengan segala fitur dan kegunaannya, dan hubungan Anda dengan Lendana Digitalindo Nusantara (“LENDANA.id” atau “Kami”) sebagai penyedia Layanan. Harap baca S&K dengan seksama karena isinya akan mempengaruhi hak dan kewajiban Anda berdasarkan hukum. Jika Anda tidak menyetujui S&K ini, mohon untuk tidak mendaftar atau menggunakan Layanan.

Penggunaan Layanan melibatkan beberapa pihak yang masing-masing memiliki hak dan kewajiban yang perlu dipenuhi. Pihak-pihak tersebut adalah:

LENDANA.id, sebagai penyedia Layanan; dan.
Pengguna Layanan (“Pengguna”), yaitu individu yang bertujuan untuk mencari informasi lowongan pekerjaan dan/atau melamar pekerjaan (“Pencari Kerja”) dan individu atau entitas bisnis yang sedang mencari pekerja atau karyawan pada Layanan (“Perusahaan”) serta individu yang menggunakan Layanan untuk mengakses soal-soal pada fitur Belajar yang terdapat pada Layanan.
Ketentuan Umum Pengguna

Dengan menggunakan Layanan, Anda menyatakan bahwa:

Anda setuju untuk terikat dengan S&K yang ditetapkan serta kebijakan mengenai pembaruan S&K yang dapat diubah secara sepihak oleh LENDANA.id di kemudian hari. Anda dipersilahkan untuk tidak menggunakan dan/atau mengakses Layanan jika tidak setuju untuk terikat dengan S&K ini atau pun pembaruannya.
Jika ada pertentangan antara S&K dengan kontrak apapun yang Anda miliki dengan LENDANA.id, Ketentuan yang lebih khusus diatur di dalam perjanjian tersebutlah ini yang akan diutamakan (kecuali dinyatakan lain).
A. Registrasi

Untuk mendaftarkan akun pada Layanan, anda harus berusia 18 (delapan belas) tahun ke atas atau dinyatakan dewasa berdasarkan peraturan perundang-undangan yang berlaku di wilayah Republik Indonesia.
Data-data yang Anda masukkan untuk proses registrasi harus merupakan data yang benar, tepat dan lengkap.
Anda diperbolehkan mendaftar atas nama pribadi atau perusahaan tempat anda bekerja (apabila Anda memiliki hak dan kewenangan yang sah), dan tidak diperbolehkan mendaftar atas nama orang atau perusahaan lain.
Anda bertanggung jawab untuk menjaga kerahasiaan data yang Anda gunakan untuk masuk ke akun Anda.
Dalam hal Anda lupa kata sandi akun, Anda dapat mengikuti langkah-langkah yang terdapat pada Layanan untuk membuat kata sandi baru. Apabila terdapat langkah tertentu yang tidak dapat Anda penuhi, maka anda tidak akan mendapatkan akses untuk membuat kata sandi baru.
Jika kami memiliki alasan untuk meyakini bahwa akan terjadi pelanggaran keamanan atau penyalahgunaan akun Anda oleh pihak yang tidak berhak, kami akan meminta Anda untuk mengubah kata sandi Anda atau kami dapat menangguhkan akun Anda demi keamanan para pihak.
B. Hak Kekayaan Intelektual

Aplikasi, situs, akun media sosial, dan seluruhmua layanan yang dimiliki LENDANA.id adalah milik eksklusif LENDANA.id atau pemberi lisensinya.
LENDANA.id dan Layanan dilindungi oleh hak cipta, merek dagang, dan hak kekayaan intelektual lainnya berdasarkan peraturan perundang-undangan Republik Indonesia yang mengatur mengenai hak kekayaan intelektual.
Anda dapat menggunakan dan menikmati layanan dan tampilan Layanan. Anda tidak diperkenankan untuk mereproduksi, memodifikasi, menyalin atau mendistribusikan atau menggunakan untuk tujuan komersial hal apa pun di Layanan, tanpa izin tertulis dari LENDANA.id.
Setiap pengguna Layanan setuju untuk tidak menggunakan Layanan dengan cara apa pun yang melanggar hak kekayaan intelektual atau hak milik orang lain seperti:
mencetak, mengunduh, menggandakan, mengirimkan atau menyalin, mereproduksi, mendistribusikan ulang, menerbitkan ulang, atau menggunakan informasi pribadi apapun tentang pengguna lain, kecuali telah mendapatkan izin tertulis atau dinyatakan lain pada S&K;
merekayasa balik (reverse engineer) atau mendekompilasi bagian manapun dari Layanan;
Dalam hal Anda lupa kata sandi akun, Anda dapat mengikuti langkah-langkah yang terdapat pada Layanan untuk membuat kata sandi baru. Apabila terdapat langkah tertentu yang tidak dapat Anda penuhi, maka anda tidak akan mendapatkan akses untuk membuat kata sandi baru.
Jika kami memiliki alasan untuk meyakini bahwa akan terjadi pelanggaran keamanan atau penyalahgunaan akun Anda oleh pihak yang tidak berhak, kami akan meminta Anda untuk mengubah kata sandi Anda atau kami dapat menangguhkan akun Anda demi keamanan para pihak.
C. Penggunaan Layanan

Layanan dapat diakses bagi:
individu yang ingin mencari informasi mengenai lowongan pekerjaan dan/atau melamar pekerjaan;
perusahaan atau pencari kandidat pekerja untuk lowongan kerja yang valid;
individu yang tergabung atau pun memiliki minat untuk bergabung di komunitas yang tersedia pada Layanan;
setiap orang yang ingin mengetahui fitur yang terdapat pada Layanan tanpa adanya itikad buruk untuk melanggar Hak Kekayaan Intelektual yang dimiliki LENDANA.id.
Penggunaan Anda atas Layanan juga tunduk pada kontrak dan/atau perjanjian lain yang mungkin Anda miliki dengan LENDANA.id. Jika ada pertentangan antara S&K dan kontrak dan/atau perjanjian apa pun yang Anda miliki dengan LENDANA.id, Ketentuan di dalam perjanjian yang lebih khusus yang akan berlaku (kecuali dinyatakan lain).
Dengan menggunakan Layanan yang terdapat pada Layanan, anda menyatakan bahwa:
tidak akan melanggar hak kekayaan intelektual milik orang lain yang berhubungan dengan Layanan;
tidak akan membagikan informasi kredensial untuk masuk ke akun Layanan Anda pada pihak ketiga mana pun;
melanggar atau berusaha melanggar sistem keamanan Layanan;
tidak menggunakan akun secara tanpa hak;
tidak akan melakukan penipuan, pengecohan, diskriminasi, atau pun penggunaan Layanan dengan cara-cara lain yang tidak diperbolehkan pada S&K dan/atau hukum yang berlaku;
bertanggung jawab atas setiap hal yang Anda unggah; dan
setuju dengan segala isi S&K dan Kebijakan Privasi LENDANA.id.
Anda bertanggung jawab untuk menjaga kerahasiaan data yang Anda gunakan untuk masuk ke akun Anda.
Dalam hal Anda lupa kata sandi akun, Anda dapat mengikuti langkah-langkah yang terdapat pada Layanan untuk membuat kata sandi baru. Apabila terdapat langkah tertentu yang tidak dapat Anda penuhi, maka anda tidak akan mendapatkan akses untuk membuat kata sandi baru.
Jika kami memiliki alasan untuk meyakini bahwa akan terjadi pelanggaran keamanan atau penyalahgunaan akun Anda oleh pihak yang tidak berhak, kami akan meminta Anda untuk mengubah kata sandi Anda atau kami dapat menangguhkan akun Anda demi keamanan para pihak.
D. Ketersediaan Layanan LENDANA.id

Kami memiliki tujuan untuk menawarkan layanan terbaik kepada Anda, namun kami tidak berjanji bahwa Layanan kami akan memenuhi kebutuhan semua Anda.
Kami tidak dapat menjamin bahwa Layanan akan bebas dari kesalahan, bebas dari error, atau bahwa Layanan bebas dari virus atau mekanisme berbahaya lainnya. Jika terjadi kesalahan pada Layanan, Anda harus melaporkannya melalui Customer Service LENDANA.id melalui ops@LENDANA.id dan kami akan berusaha memperbaiki kesalahan tersebut sesegera mungkin.
Akses Anda ke Layanan mungkin akan dibatasi pada waktu tertentu saat adanya perbaikan, pemeliharaan, atau pengenalan konten, fasilitas, atau layanan baru. Kami akan berusaha memulihkan akses pada Layanan sesegera mungkin.
E. Perusahaan

Perusahaan harus mengisi data-data profil Perusahaan yang diminta pada Layanan secara lengkap dan tepat.
Perusahaan bertanggung jawab atas setiap lowongan kerja yang mereka unggah.
LENDANA.id tidak akan mengubah unggahan lowongan kerja Perusahaan secara sepihak, kecuali telah terdapat kesepakatan lain sebelumnya.
Perusahaan dilarang untuk memungut biaya selama proses rekrutmen melalui Layanan.
Perusahaan wajib menjunjung tinggi kesopanan dalam berkomunikasi dengan setiap pihak pada Layanan.
Lowongan kerja yang Perusahaan unggah tidak boleh mengandung unsur diskriminatif, atau penipuan, atau pengecohan yang merugikan Pencari Kerja dan/atau LENDANA.id.
Apabila terdapat suatu lowongan kerja yang terindikasi penipuan berdasarkan penilaian kami secara sepihak, Kami akan menghubungi Perusahaan terkait. Apabila kami tidak mendapatkan jawaban yang meyakinkan pada batas waktu tertentu, LENDANA.id berhak untuk menghapus lowongan kerja tersebut pada Layanan kami.
LENDANA.id berdasarkan penilayannya sepihak dapat menghapus atau menonaktifkan akun Perusahaan jika dianggap telah melanggar S&K yang berlaku.
LENDANA.id tidak memiliki tanggung jawab hukum atas ketidaktepatan informasi lowongan kerja pada Layanan.
F. Pencari Kerja

LENDANA.id dengan ini memberi Anda hak non-eksklusif yang terbatas, dapat dihentikan, untuk mengakses dan menggunakan Layanan hanya untuk penggunaan pribadi Anda mencari peluang kerja untuk diri Anda sendiri dan bukan untuk orang lain. Saat Anda mendaftar di Layanan, Anda akan diminta untuk membuat akun dan memberikan informasi tertentu kepada LENDANA.id.
Setiap data pada profil yang Anda isi pada Layanan harus bersifat akurat, lengkap, terkini dan tidak menyesatkan. Anda tidak boleh mengisi data pada profil dengan data milik orang lain.
Anda setuju bahwa Anda bertanggung jawab penuh atas bentuk, isi, dan keakuratan setiap data yang anda berikan pada profil akun Anda.
LENDANA.id berhak untuk menawarkan layanan dan produk pihak ketiga kepada Anda dan setelah penawaran tersebut dapat dibuat oleh Layanan atau oleh pihak ketiga.
Anda memahami bahwa semua informasi yang Anda berikan, data profil Anda, resume, dan/atau informasi profil harus dan akan diungkapkan kepada Perusahaan.
Anda diwajibkan menjunjung tinggi kesopanan dalam berkomunikasi dengan setiap pihak pada Layanan.
LENDANA.id berhak untuk menghapus atau menonaktifkan akun Anda dan semua data Anda setelah lama tidak aktif atau dianggap melanggar S&K yang berlaku.
Anda dapat melaporkan lowongan kerja yang terindikasi penipuan dengan menghubungi Customer Service LENDANA.id melalui ops@LENDANA.id
G. Tautan Pihak Ketiga

Layanan mungkin berisi tautan ke situs lain yang dimiliki oleh selain LENDANA.id. Kami tidak bertanggung jawab atas isi situs-situs tersebut. Kami memiliki hak, tetapi bukanlah merupakan suatu keharusan untuk melarang penggunaan tautan situs lain di Layanan. Kami akan menyajikan beberapa tautan yang dapat berfungsi sebagai informasi mengenai situs dari suatu Perusahaan atau tautan yang digunakan untuk melaksanakan proses rekrutmen (contoh: wawancara) namun bukan merupakan bentuk dukungan dari LENDANA.id kepada konten di situs web pihak ketiga tersebut.

H. Yurisdiksi dan Hukum yang Berlaku

S&K ini diatur berdasarkan hukum yang pada saat ini berlaku di Republik Indonesia. Dengan menggunakan Layanan, Anda sepakat untuk tunduk dan terikat pada yurisdiksi pengadilan di seluruh Republik Indonesia.

I. Ganti Rugi

Pengguna setuju untuk tidak membebankan ganti rugi yang timbul dari atau terkait dengan penggunaan Layanan oleh pengguna atau kontennya atau pelanggaran pengguna terhadap S&K, untuk sejauh tidak dilarang oleh hukum yang berlaku. Ganti rugi ini akan menjadi tambahan untuk semua kewajiban pengguna lainnya berdasarkan S&K, dan tidak akan mengurangi hak atau upaya hukum lain yang tersedia menurut hukum untuk LENDANA.id.

J. Keterpisahan

Syarat dan ketentuan di dalam S&K ini akan dapat diberlakukan secara terpisah dengan satu sama lain dan keabsahan satu syarat dan/atau ketentuan tidak akan berpengaruh dengan ketentuan lainnya yang tidak sah. Dalam hal terdapat ketentuan atau bagian dari S&K yang tidak sesuai dengan ketentuan hukum yang berlaku, tidak sah atau tidak dapat dilaksanakan, keabsahan dan keberlakuan syarat dan ketentuan yang lainnya tidak akan terpengaruh, dan sebagai pengganti dari syarat atau ketentuan yang tidak sesuai dengan ketentuan hukum yang berlaku, tidak sah, atau tidak dapat dilaksanakan, akan ditambahkan sebagai bagian dari Syarat dan Ketentuan satu atau lebih ketentuan yang serupa dalam hal yang mungkin benar, sah, dan dapat dilaksanakan berdasarkan hukum yang berlaku.

K. Pembaruan S&K

LENDANA.id berhak untuk mengubah, menambah, menghapus atau mengubah S&K sewaktu-waktu secara sepihak tanpa pemberitahuan sebelumnya. Anda disarankan untuk meninjau S&K secara berkala. Apabila di kemudian hari anda merasa keberatan dengan perubahan S&K pada Layanan, sebaiknya Anda menghentikan penggunaan. Penggunaan yang berlanjut merupakan bentuk penerimaan Anda atas semua perubahan yang diterapkan pada S&K ini.






Kebijakan Privasi
Last Updated: November 29, 2022

Terima kasih telah memilih untuk menjadi bagian dari komunitas kami di Lendana Digitalindo Nusantara ("LENDANA.id" atau "kami"). Saat Anda mengunjungi situs LENDANA.id ("Situs"), aplikasi ("Aplikasi"), atau secara umum menggunakan layanan apa pun yang kami sediakan ("Layanan"), kami berkomitmen untuk melindungi informasi pribadi setiap pengguna Layanan. Dengan telah menggunakan Layanan yang mungkin diperoleh dari pelanggan, anggota/member,pembaca, mitra dan/atau pengunjung ("Pengguna"), Anda mengakui bahwa Anda telah membaca dan memahami Kebijakan Privasi yang kami miliki. Jika Anda merasa keberatan dengan salah satu atau beberapa ketentuan pada Kebijakan Privasi, dimohon untuk tidak bergabung, mengakses, melihat, mengunduh, atau menggunakan layanan apapun yang ditawarkan dan/atau tersedia pada Layanan.

LENDANA.id berhak untuk mengubah, menambah, menghapus atau mengubah Kebijakan Privasi sewaktu-waktu tanpa pemberitahuan sebelumnya. Anda disarankan untuk meninjau Kebijakan Privasi secara berkala. Apabila di kemudian hari anda merasa keberatan dengan perubahan Kebijakan Privasi pada Layanan, sebaiknya Anda menghentikan penggunaan. Penggunaan yang berlanjut merupakan bentuk penerimaan Anda atas semua perubahan yang diterapkan pada Kebijakan Privasi ini.

Pemberitahuan privasi ini berlaku untuk semua informasi yang dikumpulkan melalui Layanan kami (yang sebagaimana dijelaskan di atas, termasuk Situs dan Aplikasi kami), serta semua layanan, penjualan, pemasaran, atau acara terkait.

Harap baca Kebijakan Privasi ini dengan cermat karena ini akan membantu Anda untuk memahami apa yang kami lakukan dengan informasi atau data yang kami kumpulkan.

Tujuan Pengumpulan dan Penggunaan Informasi dan Data Pribadi
Informasi dan/atau data pribadi Anda digunakan dan dilindungi oleh PT Lendanan Digitalindo Nusantara sebagai penyedia Layanan dan situs LENDANA.id sesuai dengan peraturan perundang-undangan yang berlaku di Republik Indonesia serta Kebijakan Privasi ini. PT Lendana Digitalindo mengumpulkan dan menggunakan informasi dan data di Layanan termasuk namun tidak terbatas pada hal-hal berikut:

Melakukan verifikasi data Pengguna yang menggunakan situs dan Layanan LENDANA.id;
Mendapatkan statistik penggunaan Layanan serta menganalisisnya demi membantu pengembangan Layanan lebih lanjut;
Membantu LENDANA.id dalam mengembangkan pemasaran dan promosi di kemudian hari atau penggunaan semacamnya;
Memastikan keresmian dari data-data yang diberikan;
Melaksanakan kewajiban LENDANA.id sehubungan dengan pelaksanaan atas kerja sama dengan pihak ketiga yang didahului dengan perjanjian kerahasiaan;
Untuk mengetahui informasi kontak pengguna yang mungkin akan kami hubungi terkait dengan Layanan di masa yang akan datang;
Untuk mengelola Layanan di antara para pengguna;
Untuk mendeteksi dan mencegah adanya pelanggaran terhadap Syarat dan Ketentuan;
Mengelola sebuah undian, promosi, survey, riset pasar, atau aktivasi lainya;
Untuk memantau dan mengembangkan Layanan;
Data Pribadi harus anda perbaharui atau perbaiki secara berkala apabila memang terdapat perubahan atau kesalahan guna memastikan kesinambungan dan keamanan situs Kami. Anda wajib untuk menyediakan informasi sebagaimana diminta oleh LENDANA.id
1. INFORMASI YANG KAMI KUMPULKAN
Singkatnya: Kami dapat mengumpulkan informasi yang Anda berikan kepada kami, informasi perangkat, dan informasi mengenai interaksi anda dengan Layanan.

Kami mengumpulkan informasi yang Anda berikan secara sukarela kepada kami saat Anda mendaftar di Layanan (terkecuali password). Kami mengumpulkan informasi tentang interaksi Anda dengan Layanan, pilihan yang Anda buat, serta produk dan fitur yang Anda gunakan. Informasi yang kami kumpulkan tidak selalu sama pada Situs dan Aplikasi, bergantung dengan kebutuhan dan kepentingan kami pada masing-masing Layanan. Informasi yang kami kumpulkan dapat mencakup hal-hal berikut:

Data-data yang Anda Input pada Layanan.Kami mengumpulkan nama perusahaan; nomor telepon; alamat email; nama pengguna; dan informasi serupa lainnya. Semua informasi yang Anda berikan kepada kami harus benar, lengkap, dan akurat, dan apabila terdapat perubahan, Anda dapat mengubahnya.
Jawaban atas Pertanyaan Lamaran Kerja.Saat melamar pekerjaan menggunakan Layanan, pelamar akan dihadapkan dengan beberapa pertanyaan yang bertujuan untuk mengetahui kompetensinya terhadap lowongan kerja tersebut. Jawaban atas pertanyaan-pertanyaan yang diajukan akan kami simpan agar Perusahaan dapat dengan mudah mengakses dan menilainya.
Semua informasi pribadi yang Anda berikan kepada kami harus benar, lengkap, dan akurat, dan Anda harus memberi tahu kami jika ada perubahan pada informasi pribadi tersebut.

Informasi yang dapat secara otomatis dikumpulkan.
Kami secara otomatis mengumpulkan informasi tertentu saat Anda mengunjungi, menggunakan, atau menavigasi Layanan. Informasi ini tidak mengungkapkan identitas spesifik Anda (seperti nama atau informasi kontak Anda) tetapi dapat mencakup informasi perangkat dan penggunaan, seperti alamat IP, browser dan karakteristik perangkat, sistem operasi, preferensi bahasa, URL rujukan, nama perangkat, negara, lokasi, informasi tentang siapa dan kapan Anda menggunakan Layanan kami dan informasi teknis lainnya. Informasi ini terutama diperlukan untuk menjaga keamanan dan pengoperasian Layanan kami, dan untuk tujuan analitik dan pelaporan internal kami.

Log dan Data Penggunaan.Data log dan penggunaan terkait dengan layanan, penggunaan diagnostik, dan informasi kinerja yang dikumpulkan oleh server kami secara otomatis saat Anda mengakses atau menggunakan Layanan kami dan yang kami rekam dalam file log. Bergantung pada bagaimana Anda berinteraksi dengan Layanan kami, data log ini dapat mencakup alamat IP Anda, informasi perangkat, jenis dan pengaturan browser, dan informasi tentang aktivitas Anda di Layanan (seperti tanggal/waktu yang terkait dengan penggunaan Anda, halaman dan file yang dilihat, pencarian dan tindakan lain yang Anda lakukan seperti fitur yang Anda gunakan).
Data Perangkat.Kami mengumpulkan data perangkat seperti informasi tentang komputer, ponsel, tablet, atau perangkat lain yang Anda gunakan untuk mengakses Layanan. Tergantung pada perangkat yang digunakan, data perangkat ini dapat mencakup informasi seperti nomor identifikasi perangkat, lokasi, model perangkat keras, penyedia layanan Internet dan/atau operator seluler, informasi konfigurasi sistem operasi.
Data LokasiKami mengumpulkan data informasi seperti informasi tentang lokasi perangkat Anda, yang dapat berupa tepat atau tidak tepat. Banyaknya informasi yang kami kumpulkan tergantung pada jenis pengaturan perangkat yang Anda gunakan untuk mengakses Layanan. Misalnya, kami dapat menggunakan GPS dan teknologi lain untuk mengumpulkan data geolokasi yang memberi tahu kami lokasi Anda saat ini (berdasarkan alamat IP Anda). Anda dapat memilih untuk tidak mengizinkan kami mengumpulkan informasi ini dengan menolak akses ke informasi tersebut atau dengan menonaktifkan pengaturan Lokasi di perangkat Anda. Namun jika Anda memilih untuk menolak akses tersebut, Anda mungkin tidak dapat menggunakan aspek-aspek tertentu dari Layanan.
Informasi yang dikumpulkan dari sumber lain
Untuk meningkatkan kemampuan kami dalam memberikan pemasaran, penawaran, dan layanan yang relevan kepada Anda dan memperbarui catatan kami, kami dapat memperoleh informasi tentang Anda dari sumber lain, seperti basis data publik, program afiliasi, penyedia data, platform media sosial, maupun dari pihak ketiga lainnya. Informasi ini termasuk namun tidak terbatas pada alamat surat, jabatan, alamat email, nomor telepon, profil media sosial, dan URL media sosial. Jika Anda berinteraksi dengan kami di platform media sosial menggunakan akun media sosial Anda (misalnya Facebook atau Twitter), kami menerima informasi pribadi tentang Anda seperti nama, alamat email, dan jenis kelamin Anda. Setiap informasi pribadi yang kami kumpulkan dari akun media sosial Anda bergantung pada pengaturan privasi akun media sosial Anda.

2. BAGAIMANA KAMI MENGGUNAKAN INFORMASI PRIBADI ANDA?
Secara singkat: Kami memproses informasi Anda untuk tujuan tertentu berdasarkan kepentingan bisnis yang sah, kepatuhan terhadap kewajiban hukum, dan/atau persetujuan Anda.

Kami menggunakan informasi pribadi yang dikumpulkan melalui Layanan Kami untuk berbagai tujuan yang dijelaskan di bawah ini. Kami memproses informasi pribadi Anda untuk tujuan tersebut dengan mengandalkan kepentingan bisnis kami yang sah, untuk mengadakan atau melakukan kontrak dengan Anda, dengan persetujuan Anda, dan/atau untuk mematuhi kewajiban hukum kami.

Kami menggunakan informasi yang kami kumpulkan atau terima dengan tujuan:

Untuk memudahkan pembuatan akun dan proses masuk ke Layanan menggunakan akun pribadi. Jika Anda memilih untuk menautkan akun Anda dengan kami ke akun pihak ketiga (seperti akun Google), kami menggunakan informasi yang Anda izinkan untuk kami kumpulkan dari pihak ketiga tersebut untuk memfasilitasi pembuatan akun dan proses masuk untuk kinerja kontrak. Lihat bagian di bawah berjudul "BAGAIMANA KAMI MENANGANI LOGIN MENGGUNAKAN MEDIA SOSIAL?" untuk informasi lebih lanjut.
Untuk memposting testimonial. Kami memposting testimonial Aplikasi di media sosial kami yang mungkin berisi informasi pribadi. Jika Anda ingin memperbarui, atau menghapus testimonial Anda, silakan hubungi kami di cs@LENDANA.id.id dan pastikan untuk menyertakan nama Anda, nama Perusahaan, lokasi testimonial, dan informasi kontak.
Untuk meminta umpan balik. Kami dapat menggunakan informasi Anda untuk meminta umpan balik dan menghubungi Anda tentang penggunaan Layanan kami oleh Anda.
Mengelola pengundian hadiah dan kompetisi. Kami dapat menggunakan informasi Anda untuk mengelola pengundian hadiah dan kompetisi ketika Anda memilih untuk berpartisipasi dalam kompetisi kami.
Mengelola pengundian hadiah dan kompetisi. Kami dapat menggunakan informasi Anda untuk mengelola pengundian hadiah dan kompetisi ketika Anda memilih untuk berpartisipasi dalam kompetisi kami.
Untuk mengelola akun pengguna. Kami dapat menggunakan informasi Anda untuk tujuan mengelola Layanan kami dan menjaganya agar tetap berfungsi dengan baik.
Untuk menyampaikan dan memfasilitasi penyampaian pelayanan kepada pengguna. Kami dapat menggunakan informasi Anda untuk menyediakan layanan yang diminta terhadap Anda.
Untuk menanggapi pertanyaan pengguna. Kami dapat menggunakan informasi Anda untuk menanggapi pertanyaan tertentu yang diajukan oleh pengguna Layanan dan memecahkan masalah yang mungkin Anda miliki dalam penggunaan Layanan kami.
Untuk mengirimkan iklan yang bertarget kepada Anda. Kami dapat menggunakan informasi Anda untuk mengembangkan dan menampilkan konten dan iklan yang dipersonalisasi, yang disesuaikan dengan minat dan/atau lokasi Anda dan untuk mengukur efektivitasnya.
3. APAKAH INFORMASI ANDA AKAN DIBAGIKAN KEPADA SIAPAPUN?
Secara singkat: Kami hanya membagikan informasi dengan persetujuan Anda, untuk mematuhi peraturan perundang-undangan yang berlaku di wilayah Republik Indonesia, untuk menyediakan layanan kepada Anda, untuk melindungi hak Anda, atau untuk memenuhi kewajiban bisnis.

Kami dapat memproses atau membagikan data Anda yang kami miliki berdasarkan hal-hal berikut:

Persetujuan: Kami dapat memproses data Anda jika Anda telah memberi kami persetujuan khusus untuk menggunakan informasi pribadi Anda untuk tujuan tertentu.
Kepentingan yang Sah: Kami dapat memproses data Anda jika diperlukan secara wajar untuk mencapai kepentingan bisnis kami yang sah.
Pelaksanaan Kontrak: Jika kami telah menandatangani kontrak dengan Anda, kami dapat memproses informasi pribadi Anda untuk memenuhi persyaratan kontrak kami.
Kewajiban Hukum: Kami dapat mengungkapkan informasi Anda di mana kami secara hukum diharuskan melakukannya untuk mematuhi hukum yang berlaku, permintaan pemerintah, proses peradilan, perintah pengadilan, atau proses hukum.
Kepentingan Vital:Kami dapat mengungkapkan informasi Anda jika kami yakin perlu untuk menyelidiki, mencegah, atau mengambil tindakan terkait potensi pelanggaran terhadap kebijakan kami, dugaan penipuan, situasi yang melibatkan potensi ancaman terhadap keselamatan siapapun dan aktivitas ilegal, atau sebagai bukti dalam litigasi di mana kita terlibat.
Lebih khusus lagi, kami mungkin perlu memproses data Anda atau memberikan informasi pribadi Anda dalam situasi berikut:

Transfer Bisnis. Kami dapat membagikan atau mentransfer informasi Anda sehubungan dengan, atau selama negosiasi, merger, penjualan aset perusahaan, pembiayaan, atau akuisisi semua atau sebagian dari bisnis kami ke perusahaan lain.
Vendor, Konsultan, dan Penyedia Layanan Pihak Ketiga Lainnya. Kami dapat membagikan data Anda dengan vendor pihak ketiga, penyedia layanan, atau agen yang melakukan layanan untuk kami atau atas nama kami dan memerlukan akses ke informasi tersebut untuk melakukan pekerjaan itu. Contohnya meliputi: analisis data, pengiriman email, layanan hosting, dan upaya pemasaran. Kami dapat mengizinkan pihak ketiga yang dipilih untuk menggunakan teknologi tracking pada Layanan, yang akan memungkinkan mereka untuk mengumpulkan data atas nama kami tentang bagaimana Anda berinteraksi dengan Layanan kami dari waktu ke waktu. Informasi ini dapat digunakan untuk, antara lain, menganalisis dan melacak data, menentukan popularitas konten, halaman, atau fitur tertentu, dan lebih memahami aktivitas Anda di dalam Layanan. Kecuali dijelaskan dalam pemberitahuan ini, kami tidak membagikan, menjual, menyewakan, atau memperdagangkan informasi Anda dengan pihak ketiga untuk tujuan promosi mereka.
Afiliasi. Kami dapat membagikan informasi Anda dengan afiliasi kami, dalam hal ini kami akan meminta afiliasi tersebut untuk menghormati pemberitahuan privasi ini. Afiliasi termasuk perusahaan induk kami dan anak perusahaan, mitra usaha patungan, atau perusahaan lain yang kami kendalikan atau yang berada di bawah kendali yang sama dengan kami.
Pengguna lain. Saat Anda membagikan informasi pribadi atau berinteraksi dengan area publik Layanan, informasi pribadi tersebut dapat dilihat oleh semua pengguna dan dapat disediakan untuk publik di luar Layanan selamanya. Jika Anda berinteraksi dengan pengguna lain dari Layanan kami dan mendaftar untuk Layanan kami melalui jejaring sosial (seperti Facebook), kontak yang Anda miliki di media sosial akan melihat nama, foto profil, dan deskripsi aktivitas Anda. Demikian pula, pengguna lain akan dapat melihat deskripsi aktivitas Anda, berkomunikasi dengan Anda dalam Layanan kami, dan melihat profil Anda.
4. DENGAN SIAPA INFORMASI ANDA AKAN DIBAGIKAN?
Secara singkat: Kami hanya membagikan informasi pribadi anda kepada pihak-pihak yang disebutkan di poin ini.

Kami hanya membagikan dan mengungkapkan informasi Anda dengan pihak ketiga berikut. Kami telah mengkategorikan masing-masing pihak sehingga Anda dapat dengan mudah memahami tujuan praktik pengumpulan dan pemrosesan data kami. Jika kami telah memproses data Anda berdasarkan persetujuan Anda dan Anda ingin mencabut persetujuan Anda, silakan hubungi kami menggunakan detail kontak yang tersedia di bagian bawah berjudul "BAGAIMANA ANDA DAPAT MENGHUBUNGI KAMI TENTANG KEBIJAKAN PRIVASI INI?".

Iklan Media Sosial
Iklan Facebook dan Instagram
Mobile Analytics
Google Analytics for Firebase, Google Analytics dan Google Tag Manager
Website Performance Monitoring
Firebase Crash Reporting
5. PILIHAN DAN AKSES INFORMASI PRIBADI
Kami memiliki tujuan untuk untuk memperjelas informasi pribadi apa yang kami kumpulkan dan tetap memberikan Anda hak untuk membuat pilihan untuk mengubah atau menghapus informasi pribadi yang telah Anda berikan. Anda berhak untuk:

Mengakses informasi pribadi pada profil Anda;
Mengubah informasi pribadi yang terdapat pada profil Anda;
Menghapus akun atau profil Anda;
Memilih untuk tidak berlangganan materi pemasaran dari LENDANA.id.
Anda dapat memilih untuk menghapus Akun dan segala hal yang terdapat pada profil Anda. Namun apabila sebelumnya Anda telah mendaftar pada suatu lowongan kerja pada Layanan, Perusahaan akan tetap memiliki informasi yang terdapat pada profil Anda.

6. APAKAH KAMI MENGGUNAKAN COOKIES DAN TEKNOLOGI PELACAKAN LAINNYA?
Kami dapat menggunakan cookie dan teknologi pelacakan serupa untuk mengakses atau menyimpan informasi. Apabila anda merasa keberatan dengan adanya kebijakan ini, Anda dapat menolaknya pada pemberitahuan mengenai hal ini saat anda mengunjungi Layanan.

7. BAGAIMANA KAMI MENANGANI LOGIN MENGGUNAKAN MEDIA SOSIAL?
Secara singkat: Jika Anda memilih untuk mendaftar atau masuk ke layanan kami menggunakan akun media sosial, kami mungkin memiliki akses ke informasi tertentu tentang Anda.

Layanan kami menawarkan Anda fitur untuk mendaftar dan login menggunakan detail akun media sosial pihak ketiga Anda (seperti login menggunakan akun Google). Jika Anda memilih untuk melakukan ini, kami akan menerima informasi profil tertentu tentang Anda dari penyedia media sosial Anda.

Informasi profil yang kami terima bervariasi, tergantung pada penyedia media sosial yang bersangkutan, tetapi biasanya akan menyertakan nama, alamat email, dan nomor telepon Anda. Kami menggunakan Firebase Authentication untuk login menggunakan media sosial dan mengacu pada kebijakan privasi berikut.

Kami akan menggunakan informasi yang kami terima hanya untuk tujuan yang dijelaskan dalam pemberitahuan privasi ini atau yang dijelaskan kepada Anda di Layanan terkait. Harap dicatat bahwa kami tidak mengontrol, dan tidak bertanggung jawab atas, penggunaan lain dari informasi pribadi Anda oleh penyedia media sosial pihak ketiga Anda. Kami menyarankan Anda meninjau pemberitahuan privasi mereka untuk memahami bagaimana mereka mengumpulkan, menggunakan, dan membagikan informasi pribadi Anda, dan bagaimana Anda dapat mengatur preferensi privasi Anda di situs dan aplikasi mereka.

8. BERAPA LAMA KAMI MENYIMPAN INFORMASI ANDA?
Secara singkat: Kami menyimpan informasi Anda selama diperlukan untuk memenuhi tujuan yang diuraikan dalam pemberitahuan privasi ini kecuali diwajibkan lain oleh hukum yang berlaku.

Kami hanya akan menyimpan informasi pribadi Anda selama diperlukan untuk tujuan yang ditetapkan dalam kebijakan privasi ini, kecuali periode penyimpanan yang lebih lama diperlukan dan diizinkan oleh hukum yang berlaku.

Ketika kami sudah tidak memiliki kebutuhan bisnis yang sah untuk memproses informasi pribadi Anda, kami akan menghapus atau menganonimkan informasi tersebut, atau, jika tidak memungkinkan (misalnya karena informasi pribadi Anda telah disimpan dalam arsip cadangan), kami akan dengan aman menyimpan informasi pribadi Anda dan mengisolasinya dari pemrosesan lebih lanjut hingga penghapusan dapat dilakukan.

9. BAGAIMANA KAMI MENJAGA KEAMANAN INFORMASI ANDA?
Kami bertujuan untuk melindungi informasi pribadi Anda melalui sistem keamanan teknis.

Kami telah menerapkan langkah-langkah keamanan teknis yang dirancang untuk melindungi keamanan informasi pribadi apapun yang kami proses. Namun, terlepas dari perlindungan dan upaya kami untuk mengamankan informasi Anda, tidak ada transmisi elektronik melalui Internet atau teknologi penyimpanan informasi yang dapat dijamin 100% aman. Kami tidak dapat menjanjikan atau menjamin bahwa peretas atau pihak ketiga tidak sah lainnya tidak akan mampu mengalahkan keamanan kami, dan mengumpulkan, mengakses, mencuri, atau mengubah informasi Anda secara tidak semestinya. Meskipun kami akan melakukan yang terbaik untuk melindungi informasi pribadi Anda, transmisi informasi pribadi ke dan dari Layanan kami adalah risiko Anda sendiri. Anda hanya boleh mengakses Layanan dalam lingkungan dan akses internet yang aman.

10. APAKAH KAMI MENGUMPULKAN INFORMASI DARI ANAK DI BAWAH UMUR?
Secara singkat: Kami tidak dengan sengaja mengumpulkan data dari anak-anak di bawah usia 18 tahun.

Kami tidak dengan sengaja meminta data dari atau memasarkan Layanan kepada anak-anak di bawah usia 18 tahun. Dengan menggunakan Layanan, Anda menyatakan bahwa Anda setidaknya berusia 18 tahun atau bahwa Anda adalah orang tua atau wali dari anak di bawah umur tersebut dan menyetujuinya untuk menggunakan Layanan. Jika kami mengetahui bahwa informasi pribadi dari pengguna berusia kurang dari 18 tahun telah dikumpulkan, kami akan menonaktifkan akun dan mengambil tindakan yang wajar untuk segera menghapus data tersebut dari catatan kami. Jika Anda mengetahui data apa pun yang kami kumpulkan dari anak-anak di bawah usia 18 tahun, silakan hubungi kami di cs@LENDANA.id

11. APA HAK PRIVASI ANDA?
Secara singkat: Anda dapat meninjau, mengubah, atau menghapus akun Anda kapan saja.

Jika Anda sewaktu-waktu ingin meninjau atau mengubah informasi di akun Anda atau menghentikan akun Anda, Anda dapat:

Masuk ke pengaturan akun Anda dan perbarui informasi akun Anda.
Hubungi kami menggunakan informasi kontak yang disediakan.
Atas permintaan Anda untuk menghentikan akun Anda, kami akan menonaktifkan atau menghapus akun dan informasi Anda dari database aktif kami. Namun, kami dapat menyimpan beberapa informasi dalam file kami untuk mencegah penipuan, memecahkan masalah, membantu penyelidikan, menegakkan Syarat dan Ketentuan Penggunaan kami dan/atau mematuhi persyaratan hukum yang berlaku.

Anda dapat berhenti berlangganan dari daftar email pemasaran kami kapan saja dengan mengklik tautan berhenti berlangganan di email yang kami kirim atau dengan menghubungi alamat email yang disediakan di bawah ini. Anda kemudian akan dihapus dari daftar email pemasaran – namun, kami mungkin masih berkomunikasi dengan Anda, misalnya, untuk mengirimi Anda email terkait layanan yang diperlukan untuk administrasi dan penggunaan akun Anda, untuk menanggapi permintaan layanan, atau untuk tujuan non-pemasaran lainnya.

12. APAKAH KAMI AKAN MEMPERBARUI KEBIJAKAN PRIVASI?
Singkatnya: Ya, kami akan memperbarui pemberitahuan ini seperlunya untuk mengakomodir perkembangan Layanan dengan tetap mematuhi undang-undang yang relevan.

Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Versi yang diperbarui akan ditunjukkan dengan tanggal &quot yang diperbarui dan versi yang diperbarui akan berlaku segera setelah dapat diakses. Jika kami membuat perubahan materi pada pemberitahuan Kebijakan Privasi, kami dapat memberitahu Anda dengan memposting pemberitahuan mengenai pembaruan tersebut melalui Layanan atau dengan langsung mengirimkan pemberitahuan kepada Anda. Kami menganjurkan Anda untuk meninjau pemberitahuan privasi secara berkala ataupun saat mendapatkan pemberitahuan agar Anda mengetahui tentang Kebijakan Privasi yang berlaku.

13. KONTROL UNTUK FITUR JANGAN LACAK
Sebagian besar browser web dan beberapa sistem operasi seluler dan aplikasi seluler menyertakan fitur atau pengaturan Do Not Track ("DNT) yang dapat Anda aktifkan untuk menandakan preferensi privasi Anda agar data tentang aktivitas penjelajahan online Anda dipantau dan dikumpulkan. Pada tahap ini, tidak ada standar teknologi yang seragam untuk mengenali dan mengimplementasikan sinyal DNT yang mutakhir. Karenanya, saat ini kami tidak menanggapi sinyal browser DNT atau mekanisme lain apa pun yang secara otomatis mengomunikasikan pilihan Anda untuk tidak dilacak secara online. Jika terdapat standar untuk pelacakan online yang harus kami ikuti di masa mendatang, kami akan memberitahu Anda tentang praktik tersebut dalam versi revisi dari Kebijakan Privasi ini.

14. BAGAIMANA ANDA DAPAT MENGHUBUNGI KAMI TENTANG KEBIJAKAN PRIVASI INI?
Apabila Anda memiliki pertanyaan atau komentar tentang Kebijakan Privasi ini, Anda dapat mengirim email ke cs@LENDANA.id

 ''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
