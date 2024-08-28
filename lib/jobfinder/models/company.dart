class Company {
  final String name;
  final String? urlLogo; // Keeping it optional if you want both options
  final String? assetLogo; // Adding a new field for asset path

  Company({
    required this.name,
    this.urlLogo,
    this.assetLogo,
  });
}
