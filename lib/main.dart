import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ai_tool_model.dart';
import 'ai_tool_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أدوات الذكاء الاصطناعي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Directionality(
        // تغيير الاتجاه إلى RTL
        textDirection: TextDirection.rtl,
        child: AiToolHome(),
      ),
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
  String selectedCategory = 'All'; // الفئة الافتراضية
  bool isCategorySelected = false;

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
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // جعل المحتوى في الوسط
          children: [
            Text('ABDSH_SOFT'),

            SizedBox(width: 8), // مسافة بين الصورة والنص
            CircleAvatar(
              backgroundImage: AssetImage('assets/m.jpg'),
              radius: 20,
            ), // النص
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: isCategorySelected
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isCategorySelected = false;
                    selectedCategory = 'All';
                    filterTools(searchQuery, 'All');
                  });
                },
              )
            : null,
      ),
      body: isCategorySelected
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    onChanged: (value) {
                      filterTools(value, selectedCategory);
                    },
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTools.length,
                    itemBuilder: (context, index) {
                      AiTool tool = filteredTools[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        elevation: 4,
                        child: ListTile(
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
                          title: Text(
                            tool.title,
                            textDirection: TextDirection.rtl,
                          ),
                          subtitle: Text(
                            tool.description,
                            textDirection: TextDirection.rtl,
                          ),
                          trailing: Text(
                            tool.category,
                            textDirection: TextDirection.rtl,
                          ),
                          onTap: () {
                            _launchUrl(tool.websiteUrl);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCategoryCard(
                    'All', [Colors.blueAccent, Colors.purpleAccent]),
                _buildCategoryCard(
                    'Generative Code', [Colors.purple, Colors.deepPurple]),
                _buildCategoryCard(
                    'Podcasting', [Colors.orange, Colors.deepOrange]),
                _buildCategoryCard(
                    'Productivity', [Colors.green, Colors.lightGreen]),
                _buildCategoryCard('Image Scanning', [Colors.red, Colors.pink]),
                _buildCategoryCard('Video Editing', [Colors.teal, Colors.cyan]),
                _buildCategoryCard(
                    'Speech.To.Text', [Colors.pinkAccent, Colors.purpleAccent]),
                _buildCategoryCard('Marketing', [Colors.indigo, Colors.blue]),
                _buildCategoryCard(
                    'Self.Improvement', [Colors.cyan, Colors.teal]),
                _buildCategoryCard(
                    'Generative Art', [Colors.amber, Colors.orange]),
                _buildCategoryCard(
                    'Generative Video', [Colors.deepPurple, Colors.purple]),
                _buildCategoryCard('Chat', [Colors.lightBlue, Colors.blue]),
                _buildCategoryCard(
                    'Social Media', [Colors.lightGreen, Colors.green]),
              ],
            ),
    );
  }

  Widget _buildCategoryCard(String category, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          isCategorySelected = true;
          filterTools(searchQuery, category);
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}
