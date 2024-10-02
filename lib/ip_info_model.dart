// ignore_for_file: file_names

class IPInfo {
  final String status;
  final String country;
  final String countryCode;
  final String region;
  final String regionName;
  final String city;
  final String zip;
  final double lat;
  final double lon;
  final String timezone;
  final String isp;
  final String org;
  final String asOrg;
  final String query;

  IPInfo({
    required this.status,
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.asOrg,
    required this.query,
  });

  factory IPInfo.fromJson(Map<String, dynamic> json) {
    return IPInfo(
      status: json['status'],
      country: json['country'],
      countryCode: json['countryCode'],
      region: json['region'],
      regionName: json['regionName'],
      city: json['city'],
      zip: json['zip'],
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      isp: json['isp'],
      org: json['org'],
      asOrg: json['as'],
      query: json['query'],
    );
  }
}
