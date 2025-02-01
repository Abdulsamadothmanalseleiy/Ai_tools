import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'ai_tool_model.dart';
import 'ai_tool_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Tools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AiToolHome(),
    );
  }
}

class AiToolHome extends StatefulWidget {
  @override
  _AiToolHomeState createState() => _AiToolHomeState();
}

class _AiToolHomeState extends State<AiToolHome> {
  late Future<List<AiTool>> futureAiTools;
  List<AiTool> aiTools = [];
  List<AiTool> filteredTools = [];
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    futureAiTools = AiToolService().loadAiTools();
    futureAiTools.then((tools) {
      setState(() {
        aiTools = tools;
        filteredTools = tools;
      });
    });
  }

  void filterTools(String query, String category) {
    setState(() {
      searchQuery = query;
      selectedCategory = category;
      filteredTools = aiTools.where((tool) {
        final matchesQuery =
            tool.title.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = category == 'All' || tool.category == category;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  // Function to launch the URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Tools'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                filterTools(value, selectedCategory);
              },
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Generative Code'),
                _buildCategoryChip('Podcasting'),
                _buildCategoryChip('Productivity'),
                _buildCategoryChip('Image Scanning'),
                _buildCategoryChip('Video Editing'),
                _buildCategoryChip('Speech.To.Text'),
                _buildCategoryChip('Marketing'),
                _buildCategoryChip('Self.Improvement'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTools.length,
              itemBuilder: (context, index) {
                AiTool tool = filteredTools[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://cdn.prod.website-files.com/63994dae1033718bee6949ce/${tool.imageUrl}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(tool.title),
                  subtitle: Text(tool.description),
                  trailing: Text(tool.category),
                  onTap: () {
                    // افتح الرابط عند النقر على الأداة
                    _launchUrl(tool.websiteUrl);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (selected) {
          filterTools(searchQuery, category);
        },
      ),
    );
  }
}
