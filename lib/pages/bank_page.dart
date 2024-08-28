import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lendana5/models/request_user1.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:lendana5/repository/api_repository.dart';

class BankPage extends StatefulWidget {
  final int userId;

  const BankPage({Key? key, required this.userId}) : super(key: key);

  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  late Future<UserResponse> _user;
  String? _selectedBank; // field perusahaan
  final negaraController = TextEditingController(); // field negara
  final _formKey = GlobalKey<FormState>();

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
      negaraController.text = user.negara ?? '';
      _selectedBank =
          (user.perusahaan == 'Bank BNI' || user.perusahaan == 'Bank Nano')
              ? user.perusahaan
              : null;
    });
  }

  void _selectBank(String bankName) {
    setState(() {
      _selectedBank = bankName;
    });
  }

  Future<void> _updateUser(UserResponse snapshotData) async {
    if (!_formKey.currentState!.validate()) {
      return; // Don't submit if form is invalid
    }

    // Check required fields
    if (snapshotData.nama == null ||
        snapshotData.nama!.isEmpty ||
        snapshotData.nik == null ||
        snapshotData.nik!.isEmpty ||
        negaraController.text.isEmpty ||
        _selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Harap diisi untuk field : Nama, NIK, Bank Peminjam, and Jumlah Pinjaman')),
      );
      return;
    }

    final RequestUser1 updatedUser = RequestUser1(
      id: snapshotData.id,
      username: snapshotData.username,
      email: snapshotData.email,
      provider: snapshotData.provider,
      confirmed: snapshotData.confirmed,
      blocked: snapshotData.blocked,
      createdAt: snapshotData.createdAt,
      updatedAt: snapshotData.updatedAt,
      tanggalLahir: snapshotData.tanggalLahir,
      jenis: _selectedBank,
      status: snapshotData.status,
      domisili: snapshotData.domisili,
      hp: snapshotData.hp,
      nik: snapshotData.nik,
      pendidikan: snapshotData.pendidikan,
      tahunMasuk: snapshotData.tahunMasuk,
      tahunKeluar: snapshotData.tahunKeluar,
      namaSekolah: snapshotData.namaSekolah,
      perusahaan: _selectedBank,
      negara: negaraController.text,
      profesi: snapshotData.profesi,
      tahunKerjaMasuk: snapshotData.tahunKerjaMasuk,
      tahunKerjaKeluar: snapshotData.tahunKerjaKeluar,
      negaraTujuan: snapshotData.negaraTujuan,
      nama: snapshotData.nama,
    );

    try {
      await ApiRepository()
          .updateUser(UserResponse.fromJson(updatedUser.toJson()));
      setState(() {
        _user = ApiRepository().getUser(widget.userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank Loan Application submitted')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $error')),
      );
    }
  }

  Future<void> _confirmUpdate(UserResponse snapshotData) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: const Text('Are you sure you want to apply for loan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (shouldUpdate == true) {
      _updateUser(snapshotData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Ajukan Pinjaman',
          style: TextStyle(color: Colors.blueGrey, fontSize: 18),
        ),
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
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Bank Cards
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBankCard(
                            bankName: 'Bank BNI',
                            bankLogoAssetPath:
                                'assets/bankbni.jpg', // Update with your actual asset path
                            bankDescription:
                                'Bank Penyedia KUR untuk PMI dan UKM.',
                            loanRate: '6% per annum',
                          ),
                          _buildBankCard(
                            bankName: 'Bank Nano',
                            bankLogoAssetPath:
                                'assets/banknano.png', // Update with your actual asset path
                            bankDescription:
                                'Innovative bank  yang memberikan pinjaman berbasis Syariah',
                            loanRate: '12.0% per annum',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // TextFormField with currency formatter
                      TextFormField(
                        controller: negaraController,
                        decoration: InputDecoration(
                          labelText: 'Nilai Pinjaman Yang Diajukan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter()
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // DropdownButtonFormField for banks
                      DropdownButtonFormField<String>(
                        value: _selectedBank,
                        items: const <String>['Bank BNI', 'Bank Nano']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBank = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Bank Pemberi Pinjaman',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.account_balance),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a bank';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (snapshot.hasData) {
                            _confirmUpdate(snapshot.data!);
                          }
                        },
                        child: const Text('Ajukan Pinjaman'),
                      ),
                    ],
                  ),
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

  Widget _buildBankCard({
    required String bankName,
    required String bankLogoAssetPath,
    required String bankDescription,
    required String loanRate,
  }) {
    return GestureDetector(
      onTap: () => _selectBank(bankName),
      child: Card(
        color: _selectedBank == bankName ? Colors.blueAccent : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    bankLogoAssetPath,
                    width: 60,
                    height: 60,
                    //                color: _selectedBank == bankName ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    bankName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedBank == bankName
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                bankDescription,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      _selectedBank == bankName ? Colors.white : Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Loan Rate: $loanRate',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      _selectedBank == bankName ? Colors.white : Colors.black,
                ),
              ),
              if (_selectedBank == bankName)
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final intValue = int.parse(newText);

    final formattedText = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(intValue);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
