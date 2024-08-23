class Blog {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String content; // New content field
  final bool isFavorite;

  Blog({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.content,
    this.isFavorite = false,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    String category;
    if (json['title'].toLowerCase().contains('flutter')) {
      category = 'TUTORIAL';
    } else if (json['title'].toLowerCase().contains('business')) {
      category = 'BUSINESS';
    } else if (json['title'].toLowerCase().contains('merchant')) {
      category = 'MERCHANTS';
    } else {
      category = 'OTHER';
    }

    return Blog(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'] ?? '',
      category: category,
      content: json['content'] ?? 'No content available', // Handle content
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'category': category,
      'content': content, // Add content to the map
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      category: map['category'],
      content: map['content'], // Retrieve content from the map
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Blog copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? category,
    String? content, // Handle content in copyWith
    bool? isFavorite,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
