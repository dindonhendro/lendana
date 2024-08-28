import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lendana5/models/request_user1.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:lendana5/repository/api_repository.dart';

class UserPage1 extends StatefulWidget {
  final int userId;

  const UserPage1({Key? key, required this.userId}) : super(key: key);

  @override
  _UserPage1State createState() => _UserPage1State();
}

class _UserPage1State extends State<UserPage1> {
  late Future<UserResponse> _user;
  final _formKey = GlobalKey<FormState>(); // Key to identify the form
  final hpController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final nikController = TextEditingController();
  String? _selectedPendidikan;
  String? _selectedNegaraTujuan;

  Future<void> formData({required RequestUser1 data}) async {
    if (data != null) {
      hpController.text = data.hp ?? '';
      tanggalLahirController.text = data.tanggalLahir ?? '';
      _selectedPendidikan = data.pendidikan ?? '';
      _selectedNegaraTujuan = data.negaraTujuan ?? '';
      nikController.text = data.nik ?? '';
    } else {
      hpController.clear();
      tanggalLahirController.clear();
      _selectedPendidikan = null;
      _selectedNegaraTujuan = null;
      nikController.clear();
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
        _selectedNegaraTujuan = user.negaraTujuan == 'Korea' ||
                user.negaraTujuan == 'Japan' ||
                user.negaraTujuan == 'HongKong' ||
                user.negaraTujuan == 'Taiwan'
            ? user.negaraTujuan
            : null;
        nikController.text = user.nik ?? '';
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
                      TextFormField(
                        controller: nikController,
                        decoration: InputDecoration(
                            labelText: 'No KTP',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your No KTP';
                          } else if (value.length != 10 ||
                              !RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'No KTP must be exactly 10 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: hpController,
                        decoration: InputDecoration(
                            labelText: 'No HandPhone',
                            labelStyle: TextStyle(
                                color: Colors.blueAccent, fontSize: 15.0),
                            hintText: 'Min 10 digits',
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            prefixIcon: Icon(Icons.phone_android)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your HP Number';
                          }
                          return null;
                        },
                      ),
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
                              nik: nikController.text,
                              pendidikan: _selectedPendidikan,
                              tahunMasuk: snapshot.data!.tahunMasuk,
                              tahunKeluar: snapshot.data!.tahunKeluar,
                              namaSekolah: snapshot.data!.namaSekolah,
                              perusahaan: snapshot.data!.perusahaan,
                              negara: snapshot.data!.negara,
                              profesi: snapshot.data!.profesi,
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
