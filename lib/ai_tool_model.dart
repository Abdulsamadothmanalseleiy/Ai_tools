class AiTool {
  final String title;
  final String imageUrl;
  final String description;
  final String websiteUrl;
  final int propertyName2;
  final String category;

  AiTool({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.websiteUrl,
    required this.propertyName2,
    required this.category,
  });

  factory AiTool.fromJson(Map<String, dynamic> json) {
    return AiTool(
      title: json['Title'],
      imageUrl: json['Image_Url'],
      description: json['Descripe'],
      websiteUrl: json['Website_Url'],
      propertyName2: json['PropertyName2'],
      category: json['Category'],
    );
  }
}
