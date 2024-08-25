class RequestUser1 {
  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  String? createdAt;
  String? updatedAt;
  String? tanggalLahir;
  String? jenis;
  String? status;
  String? domisili;
  String? hp;
  String? nik;
  String? pendidikan;
  String? tahunMasuk;
  String? tahunKeluar;
  String? namaSekolah;
  String? perusahaan;
  String? negara;
  String? profesi;
  String? tahunKerjaMasuk;
  String? tahunKerjaKeluar;
  String? negaraTujuan;
  String? nama;
  Role? role;

  RequestUser1(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.confirmed,
      this.blocked,
      this.createdAt,
      this.updatedAt,
      this.tanggalLahir,
      this.jenis,
      this.status,
      this.domisili,
      this.hp,
      this.nik,
      this.pendidikan,
      this.tahunMasuk,
      this.tahunKeluar,
      this.namaSekolah,
      this.perusahaan,
      this.negara,
      this.profesi,
      this.tahunKerjaMasuk,
      this.tahunKerjaKeluar,
      this.negaraTujuan,
      this.nama,
      this.role});

  RequestUser1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    tanggalLahir = json['tanggalLahir'];
    jenis = json['jenis'];
    status = json['status'];
    domisili = json['domisili'];
    hp = json['hp'];
    nik = json['nik'];
    pendidikan = json['pendidikan'];
    tahunMasuk = json['tahunMasuk'];
    tahunKeluar = json['tahunKeluar'];
    namaSekolah = json['namaSekolah'];
    perusahaan = json['perusahaan'];
    negara = json['negara'];
    profesi = json['profesi'];
    tahunKerjaMasuk = json['tahunKerjaMasuk'];
    tahunKerjaKeluar = json['tahunKerjaKeluar'];
    negaraTujuan = json['negaraTujuan'];
    nama = json['nama'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['confirmed'] = this.confirmed;
    data['blocked'] = this.blocked;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['tanggalLahir'] = this.tanggalLahir;
    data['jenis'] = this.jenis;
    data['status'] = this.status;
    data['domisili'] = this.domisili;
    data['hp'] = this.hp;
    data['nik'] = this.nik;
    data['pendidikan'] = this.pendidikan;
    data['tahunMasuk'] = this.tahunMasuk;
    data['tahunKeluar'] = this.tahunKeluar;
    data['namaSekolah'] = this.namaSekolah;
    data['perusahaan'] = this.perusahaan;
    data['negara'] = this.negara;
    data['profesi'] = this.profesi;
    data['tahunKerjaMasuk'] = this.tahunKerjaMasuk;
    data['tahunKerjaKeluar'] = this.tahunKerjaKeluar;
    data['negaraTujuan'] = this.negaraTujuan;
    data['nama'] = this.nama;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;
  String? description;
  String? type;
  String? createdAt;
  String? updatedAt;

  Role(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.createdAt,
      this.updatedAt});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
