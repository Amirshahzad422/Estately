class Property {
  final String id;
  final String title;
  final String type; // 'House', 'Apartment', 'Villa', 'Penthouse', 'Plot'
  final String listing; // 'buy', 'rent'
  final double price;
  final String location;
  final String city;
  final int bedrooms;
  final double bathrooms;
  final int area; // sqft
  final List<String> images;
  final double latitude;
  final double longitude;
  final String agentId;
  final String description;
  final List<String> amenities;
  final bool isFeatured;
  final bool isNew;
  final String status; // 'New to Market', 'New Construction', 'Pending', 'Featured'
  final double rating;
  final int reviewCount;
  final DateTime listedDate;
  final bool isPopular;

  const Property({
    required this.id,
    required this.title,
    required this.type,
    required this.listing,
    required this.price,
    required this.location,
    required this.city,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.agentId,
    required this.description,
    required this.amenities,
    this.isFeatured = false,
    this.isNew = false,
    this.status = '',
    this.rating = 4.5,
    this.reviewCount = 0,
    required this.listedDate,
    this.isPopular = false,
  });
}

class Agent {
  final String id;
  final String name;
  final String title;
  final String company;
  final String photo;
  final double rating;
  final int reviewCount;
  final int propertiesSold;
  final int yearsExperience;
  final String phone;
  final String email;
  final String about;
  final bool isVerified;

  const Agent({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.photo,
    required this.rating,
    required this.reviewCount,
    required this.propertiesSold,
    required this.yearsExperience,
    required this.phone,
    required this.email,
    required this.about,
    this.isVerified = true,
  });
}

class Review {
  final String author;
  final String avatar;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.author,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class Enquiry {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyImage;
  final String message;
  final DateTime date;
  final String status;

  const Enquiry({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyImage,
    required this.message,
    required this.date,
    this.status = 'Pending',
  });
}

