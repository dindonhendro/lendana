class UserResponse {
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
  String? bank;
  String? jumlahPinjam;
  String? pengalaman;
  String? tahunKerjaMasuk;
  String? tahunKerjaKeluar;
  String? negaraTujuan;
  String? nama;
  Role? role;
  Paklaring? paklaring;
  Paklaring? ktp;
  Paklaring? passport;
  Paklaring? kk;
  Paklaring? dokumen1;
  Paklaring? foto;

  UserResponse({
    this.id,
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
    this.bank,
    this.jumlahPinjam,
    this.pengalaman,
    this.tahunKerjaMasuk,
    this.tahunKerjaKeluar,
    this.negaraTujuan,
    this.nama,
    this.role,
    this.paklaring,
    this.ktp,
    this.passport,
    this.kk,
    this.dokumen1,
    this.foto,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
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
    bank = json['bank'];
    jumlahPinjam = json['jumlahPinjam'];
    pengalaman = json['pengalaman'];
    tahunKerjaMasuk = json['tahunKerjaMasuk'];
    tahunKerjaKeluar = json['tahunKerjaKeluar'];
    negaraTujuan = json['negaraTujuan'];
    nama = json['nama'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    paklaring = json['paklaring'] != null
        ? Paklaring.fromJson(json['paklaring'])
        : null;
    ktp = json['ktp'] != null ? Paklaring.fromJson(json['ktp']) : null;
    passport =
        json['passport'] != null ? Paklaring.fromJson(json['passport']) : null;
    kk = json['kk'] != null ? Paklaring.fromJson(json['kk']) : null;
    dokumen1 =
        json['dokumen1'] != null ? Paklaring.fromJson(json['dokumen1']) : null;
    foto = json['foto'] != null ? Paklaring.fromJson(json['foto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['provider'] = provider;
    data['confirmed'] = confirmed;
    data['blocked'] = blocked;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['tanggalLahir'] = tanggalLahir;
    data['jenis'] = jenis;
    data['status'] = status;
    data['domisili'] = domisili;
    data['hp'] = hp;
    data['nik'] = nik;
    data['pendidikan'] = pendidikan;
    data['tahunMasuk'] = tahunMasuk;
    data['tahunKeluar'] = tahunKeluar;
    data['namaSekolah'] = namaSekolah;
    data['perusahaan'] = perusahaan;
    data['negara'] = negara;
    data['profesi'] = profesi;
    data['bank'] = bank;
    data['jumlahPinjam'] = jumlahPinjam;
    data['pengalaman'] = pengalaman;
    data['tahunKerjaMasuk'] = tahunKerjaMasuk;
    data['tahunKerjaKeluar'] = tahunKerjaKeluar;
    data['negaraTujuan'] = negaraTujuan;
    data['nama'] = nama;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    if (paklaring != null) {
      data['paklaring'] = paklaring!.toJson();
    }
    if (ktp != null) {
      data['ktp'] = ktp!.toJson();
    }
    if (passport != null) {
      data['passport'] = passport!.toJson();
    }
    if (kk != null) {
      data['kk'] = kk!.toJson();
    }
    if (dokumen1 != null) {
      data['dokumen1'] = dokumen1!.toJson();
    }
    if (foto != null) {
      data['foto'] = foto!.toJson();
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

  Role({
    this.id,
    this.name,
    this.description,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Paklaring {
  int? id;
  String? name;
  String? alternativeText;
  String? caption;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;
  String? previewUrl;
  String? provider;
  dynamic providerMetadata;
  String? createdAt;
  String? updatedAt;

  Paklaring({
    this.id,
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  Paklaring.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alternativeText = json['alternativeText'];
    caption = json['caption'];
    width = json['width'];
    height = json['height'];
    formats =
        json['formats'] != null ? Formats.fromJson(json['formats']) : null;
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    url = json['url'];
    previewUrl = json['previewUrl'];
    provider = json['provider'];
    providerMetadata = json['provider_metadata'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['alternativeText'] = alternativeText;
    data['caption'] = caption;
    data['width'] = width;
    data['height'] = height;
    if (formats != null) {
      data['formats'] = formats!.toJson();
    }
    data['hash'] = hash;
    data['ext'] = ext;
    data['mime'] = mime;
    data['size'] = size;
    data['url'] = url;
    data['previewUrl'] = previewUrl;
    data['provider'] = provider;
    data['provider_metadata'] = providerMetadata;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Formats {
  Thumbnail? thumbnail;
  Thumbnail? small;

  Formats({this.thumbnail, this.small});

  Formats.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
    small = json['small'] != null ? Thumbnail.fromJson(json['small']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (thumbnail != null) {
      data['thumbnail'] = thumbnail!.toJson();
    }
    if (small != null) {
      data['small'] = small!.toJson();
    }
    return data;
  }
}

class Thumbnail {
  String? name;
  String? hash;
  String? ext;
  String? mime;
  String? path;
  int? width;
  int? height;
  double? size;
  int? sizeInBytes;
  String? url;

  Thumbnail({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.path,
    this.width,
    this.height,
    this.size,
    this.sizeInBytes,
    this.url,
  });

  Thumbnail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    path = json['path'];
    width = json['width'];
    height = json['height'];
    size = json['size'];
    sizeInBytes = json['sizeInBytes'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['hash'] = hash;
    data['ext'] = ext;
    data['mime'] = mime;
    data['path'] = path;
    data['width'] = width;
    data['height'] = height;
    data['size'] = size;
    data['sizeInBytes'] = sizeInBytes;
    data['url'] = url;
    return data;
  }
}
