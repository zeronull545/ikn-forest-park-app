class ForestParkModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String locationName;
  final int visitorCount;
  final double rating;
  final String openingHours;
  final bool isCheckedInByMe;

  ForestParkModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.visitorCount = 0,
    this.rating = 4.5,
    required this.openingHours,
    this.isCheckedInByMe = false,
  });

  factory ForestParkModel.fromJson(Map<String, dynamic> json) {
    return ForestParkModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?auto=format&fit=crop&w=800&q=80',
      latitude: double.parse((json['latitude'] ?? '-0.95').toString()),
      longitude: double.parse((json['longitude'] ?? '116.7').toString()),
      locationName: json['location_name'] ?? 'IKN Nusantara',
      visitorCount: json['visitor_count'] ?? 0,
      rating: double.parse((json['rating'] ?? '4.5').toString()),
      openingHours: json['opening_hours'] ?? 'Setiap Hari: 06:00 - 18:00',
      isCheckedInByMe: json['is_checked_in_by_me'] ?? false,
    );
  }

  ForestParkModel copyWith({
    bool? isCheckedInByMe,
    int? visitorCount,
  }) {
    return ForestParkModel(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      visitorCount: visitorCount ?? this.visitorCount,
      rating: rating,
      openingHours: openingHours,
      isCheckedInByMe: isCheckedInByMe ?? this.isCheckedInByMe,
    );
  }
}
