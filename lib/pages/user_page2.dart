import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lendana5/models/request_user1.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:lendana5/repository/api_repository.dart';

class UserPage2 extends StatefulWidget {
  final int userId;

  const UserPage2({Key? key, required this.userId}) : super(key: key);

  @override
  _UserPage2State createState() => _UserPage2State();
}

class _UserPage2State extends State<UserPage2> {
  late Future<UserResponse> _user;
  final _formKey = GlobalKey<FormState>(); // Key to identify the form
  final hpController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final pengalamanController = TextEditingController();
  String? _selectedPendidikan;
  String? _selectedProfesi;
  String? _selectedNegaraTujuan;

  Future<void> formData({required RequestUser1 data}) async {
    if (data != null) {
      hpController.text = data.hp ?? '';
      tanggalLahirController.text = data.tanggalLahir ?? '';
      _selectedPendidikan = data.pendidikan ?? '';
      _selectedProfesi = data.profesi ?? '';
      _selectedNegaraTujuan = data.negaraTujuan ?? '';
      pengalamanController.text = data.pengalaman ?? '';
    } else {
      hpController.clear();
      tanggalLahirController.clear();
      _selectedPendidikan = null;
      _selectedProfesi = null;
      _selectedNegaraTujuan = null;
      pengalamanController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _user = ApiRepository().getUser(widget.userId);
    _user.then((user) {
      setState(() {
        hpController.text = user.hp ?? '';
        tanggalLahirController.text = user.tanggalLahir ?? '';
        _selectedPendidikan = user.pendidikan == 'SD' ||
                user.pendidikan == 'SMP' ||
                user.pendidikan == 'SMA' ||
                user.pendidikan == 'D3' ||
                user.pendidikan == 'S1'
            ? user.pendidikan
            : null;
        _selectedProfesi = user.profesi == 'tukang1' ||
                user.profesi == 'tukang2' ||
                user.profesi == 'tukang3' ||
                user.profesi == 'tukang4' ||
                user.profesi == 'tukang5'
            ? user.profesi
            : null;
        _selectedNegaraTujuan = user.negaraTujuan == 'Korea' ||
                user.negaraTujuan == 'Japan' ||
                user.negaraTujuan == 'HongKong' ||
                user.negaraTujuan == 'Taiwan'
            ? user.negaraTujuan
            : null;
        pengalamanController.text = user.pengalaman ?? '';
      });
    });
  }

  Future<void> _deleteUser(int id) async {
    try {
      await ApiRepository().deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
//        title: const Text('User Page'),
      ),
      body: FutureBuilder<UserResponse>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey, // Assign the form key to the Form widget
                  child: Column(
                    children: [
                      Text(
                        'Lengkapi Data Diri Anda',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        //  style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Pendidikan Terakhir',
                          labelStyle: TextStyle(
                              color: Colors.blueAccent, fontSize: 15.0),
                          prefixIcon: Icon(Icons.school),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(
                            10), // If using Flutter version >= 3.3.0
                        dropdownColor: Colors.red[200],
                        value: _selectedPendidikan,
                        items: <String>['SD', 'SMP', 'SMA', 'D3', 'S1']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPendidikan = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Profesi',
                          labelStyle: TextStyle(
                              color: Colors.blueAccent, fontSize: 15.0),
                          prefixIcon: Icon(Icons.work),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(
                            10), // If using Flutter version >= 3.3.0
                        dropdownColor: Colors.red[200],
                        value: _selectedProfesi,
                        items: <String>[
                          'Perawat Lansia (Kaigo)',
                          'Industri Makanan',
                          'Restoran (Gaishokugyou)',
                          'Agrikultur (Nougyou)',
                          'OTHERS'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProfesi = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Negara Tujuan',
                          labelStyle: TextStyle(
                              color: Colors.blueAccent, fontSize: 15.0),
                          prefixIcon: Icon(Icons.flight),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: _selectedNegaraTujuan,
                        items: <String>['Korea', 'Japan', 'HongKong', 'Taiwan']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedNegaraTujuan = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: pengalamanController,
                        decoration: InputDecoration(
                            labelText: 'pengalaman',
                            labelStyle: TextStyle(
                                color: Colors.blueAccent, fontSize: 15.0),
                            hintText: '10 digits',
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            prefixIcon: Icon(Icons.credit_card)),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            RequestUser1 updatedUser = RequestUser1(
                              id: snapshot.data!.id,
                              username: snapshot.data!.username,
                              email: snapshot.data!.email,
                              provider: snapshot.data!.provider,
                              confirmed: snapshot.data!.confirmed,
                              blocked: snapshot.data!.blocked,
                              createdAt: snapshot.data!.createdAt,
                              updatedAt: snapshot.data!.updatedAt,
                              tanggalLahir: snapshot.data!.tanggalLahir,
                              jenis: snapshot.data!.jenis,
                              status: snapshot.data!.status,
                              domisili: snapshot.data!.domisili,
                              hp: hpController.text,
                              nik: snapshot.data!.nik,
                              pendidikan: _selectedPendidikan,
                              tahunMasuk: snapshot.data!.tahunMasuk,
                              tahunKeluar: snapshot.data!.tahunKeluar,
                              namaSekolah: snapshot.data!.namaSekolah,
                              perusahaan: snapshot.data!.perusahaan,
                              negara: snapshot.data!.negara,
                              profesi: snapshot.data!.profesi,
                              pengalaman: pengalamanController.text,
                              tahunKerjaMasuk: snapshot.data!.tahunKerjaMasuk,
                              tahunKerjaKeluar: snapshot.data!.tahunKerjaKeluar,
                              negaraTujuan: _selectedNegaraTujuan,
                              nama: snapshot.data!.nama,
                              // role: snapshot.data!.role,
                            );

                            try {
                              await ApiRepository().updateUser(
                                  UserResponse.fromJson(updatedUser.toJson()));
                              setState(() {
                                _user = ApiRepository().getUser(widget.userId);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('User updated successfully')),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to update user')),
                              );
                            }
                          }
                        },
                        child: Text('Update Data'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
