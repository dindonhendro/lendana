class ProfileResponse {
  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  String? createdAt;
  String? updatedAt;
  Profile1? profile1;

  ProfileResponse(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.confirmed,
      this.blocked,
      this.createdAt,
      this.updatedAt,
      this.profile1});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profile1 = json['profile_1'] != null
        ? new Profile1.fromJson(json['profile_1'])
        : null;
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
    if (this.profile1 != null) {
      data['profile_1'] = this.profile1!.toJson();
    }
    return data;
  }
}

class Profile1 {
  int? id;
  String? nama;
  Null? hp;
  Null? nik;
  Null? email;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  String? pendidikan;
  Foto? foto;

  Profile1(
      {this.id,
      this.nama,
      this.hp,
      this.nik,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.pendidikan,
      this.foto});

  Profile1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    hp = json['hp'];
    nik = json['nik'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    publishedAt = json['publishedAt'];
    pendidikan = json['pendidikan'];
    foto = json['foto'] != null ? new Foto.fromJson(json['foto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['hp'] = this.hp;
    data['nik'] = this.nik;
    data['email'] = this.email;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['publishedAt'] = this.publishedAt;
    data['pendidikan'] = this.pendidikan;
    if (this.foto != null) {
      data['foto'] = this.foto!.toJson();
    }
    return data;
  }
}

class Foto {
  int? id;
  String? name;
  Null? alternativeText;
  Null? caption;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;
  Null? previewUrl;
  String? provider;
  Null? providerMetadata;
  String? createdAt;
  String? updatedAt;

  Foto(
      {this.id,
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
      this.updatedAt});

  Foto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alternativeText = json['alternativeText'];
    caption = json['caption'];
    width = json['width'];
    height = json['height'];
    formats =
        json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['alternativeText'] = this.alternativeText;
    data['caption'] = this.caption;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.formats != null) {
      data['formats'] = this.formats!.toJson();
    }
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['url'] = this.url;
    data['previewUrl'] = this.previewUrl;
    data['provider'] = this.provider;
    data['provider_metadata'] = this.providerMetadata;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Formats {
  Thumbnail? thumbnail;
  Thumbnail? small;
  Thumbnail? medium;
  Thumbnail? large;

  Formats({this.thumbnail, this.small, this.medium, this.large});

  Formats.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    small =
        json['small'] != null ? new Thumbnail.fromJson(json['small']) : null;
    medium =
        json['medium'] != null ? new Thumbnail.fromJson(json['medium']) : null;
    large =
        json['large'] != null ? new Thumbnail.fromJson(json['large']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small!.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium!.toJson();
    }
    if (this.large != null) {
      data['large'] = this.large!.toJson();
    }
    return data;
  }
}

class Thumbnail {
  String? name;
  String? hash;
  String? ext;
  String? mime;
  Null? path;
  int? width;
  int? height;
  double? size;
  int? sizeInBytes;
  String? url;

  Thumbnail(
      {this.name,
      this.hash,
      this.ext,
      this.mime,
      this.path,
      this.width,
      this.height,
      this.size,
      this.sizeInBytes,
      this.url});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['path'] = this.path;
    data['width'] = this.width;
    data['height'] = this.height;
    data['size'] = this.size;
    data['sizeInBytes'] = this.sizeInBytes;
    data['url'] = this.url;
    return data;
  }
}
