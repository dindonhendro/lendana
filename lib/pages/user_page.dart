import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendana5/models/request_user1.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:lendana5/repository/api_repository.dart';

class UserPage extends StatefulWidget {
  final int userId;

  const UserPage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<UserResponse> _user;
  final nameController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final domisiliController = TextEditingController();
  String? _selectedGender;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _user = ApiRepository().getUser(widget.userId);
    _user.then((user) {
      _populateFormFields(user);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $error')),
      );
    });
  }

  void _populateFormFields(UserResponse user) {
    if (user == null) return;

    setState(() {
      nameController.text = user.nama ?? '';
      tanggalLahirController.text = user.tanggalLahir ?? '';
      _selectedGender =
          user.jenis == 'Male' || user.jenis == 'Female' ? user.jenis : null;
      _selectedStatus = user.status == 'Married' || user.status == 'Not Married'
          ? user.status
          : null;
      domisiliController.text = user.domisili ?? '';
    });
  }

  Future<void> _deleteUser(int id) async {
    try {
      await ApiRepository().deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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
      // appBar: AppBar(
      //   title: const Text('User Page'),
      // ),
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
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Name TextFormField with decoration
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tanggal Lahir TextFormField with decoration
                    TextFormField(
                      controller: tanggalLahirController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    // Gender DropdownButtonFormField with decoration
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: const <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.wc),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Status DropdownButtonFormField with decoration
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      items: const <String>['Married', 'Not Married']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.family_restroom),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Domisili TextFormField with decoration
                    TextFormField(
                      controller: domisiliController,
                      decoration: InputDecoration(
                        labelText: 'Domisili',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Update User Button
                    ElevatedButton(
                      onPressed: () async {
                        final RequestUser1 updatedUser = RequestUser1(
                          id: snapshot.data!.id,
                          username: snapshot.data!.username,
                          email: snapshot.data!.email,
                          provider: snapshot.data!.provider,
                          confirmed: snapshot.data!.confirmed,
                          blocked: snapshot.data!.blocked,
                          createdAt: snapshot.data!.createdAt,
                          updatedAt: snapshot.data!.updatedAt,
                          tanggalLahir: tanggalLahirController.text,
                          jenis: _selectedGender,
                          status: _selectedStatus,
                          domisili: domisiliController.text,
                          hp: snapshot.data!.hp,
                          nik: snapshot.data!.nik,
                          pendidikan: snapshot.data!.pendidikan,
                          tahunMasuk: snapshot.data!.tahunMasuk,
                          tahunKeluar: snapshot.data!.tahunKeluar,
                          namaSekolah: snapshot.data!.namaSekolah,
                          perusahaan: snapshot.data!.perusahaan,
                          negara: snapshot.data!.negara,
                          profesi: snapshot.data!.profesi,
                          tahunKerjaMasuk: snapshot.data!.tahunKerjaMasuk,
                          tahunKerjaKeluar: snapshot.data!.tahunKerjaKeluar,
                          negaraTujuan: snapshot.data!.negaraTujuan,
                          nama: nameController.text,
                        );

                        try {
                          await ApiRepository().updateUser(
                              UserResponse.fromJson(updatedUser.toJson()));
                          setState(() {
                            _user = ApiRepository().getUser(widget.userId);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('User updated successfully')),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update user')),
                          );
                        }
                      },
                      child: const Text('Update User'),
                    ),
                    const SizedBox(height: 20),
                    // Delete User Button
                    ElevatedButton(
                      onPressed: () => _deleteUser(widget.userId),
                      child: const Text('Delete User'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('User data not found'));
          }
        },
      ),
    );
  }
}
