import 'package:flutter/material.dart';
import 'profile_screen.dart'; 
import 'search_screen.dart'; // Import SearchScreen
import 'favourites_screen.dart';
import 'english_course_page.dart'; // Import halaman EnglishCoursePage
import 'japanese_course_page.dart'; // Import halaman JapaneseCoursePage
import 'spanish_course_page.dart'; // Import halaman SpanishCoursePage
import 'package:translator/translator.dart';

class HomeScreen extends StatefulWidget {
  final String username; // Tambahkan username
  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    HomeScreenContent(username: widget.username), // Teruskan username
    const SearchScreen(),
    const FavouritesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4B61DD),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final String username; // Tambahkan username
  const HomeScreenContent({super.key, required this.username});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final PageController _pageController = PageController(initialPage: 1000);
  final translator = GoogleTranslator();
  String _translatedGreeting = '';

  final List<String> _imagePaths = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
    'assets/image5.jpg',
  ];

  int _currentPage = 1000;
  String _translatedCategories = 'Categories';
  String _translatedCourses = 'What do you want to learn today?';
  String _translatedNoCourses = 'No courses found.';
  String _translatedSearchPlaceholder = 'Search Courses';
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  List<Map<String, dynamic>> categories = [
    {'name': 'Quiz', 'icon': Icons.quiz, 'color': 0xFF42A5F5},
    {'name': 'Grammar', 'icon': Icons.book, 'color': 0xFF66BB6A},
    {'name': 'Vocabulary', 'icon': Icons.text_fields, 'color': 0xFFAB47BC},
    {'name': 'Listening', 'icon': Icons.headphones, 'color': 0xFF29B6F6},
    {'name': 'Speaking', 'icon': Icons.mic, 'color': 0xFFEF5350},
    {'name': 'Writing', 'icon': Icons.edit, 'color': 0xFF8E24AA},
    {'name': 'Reading', 'icon': Icons.chrome_reader_mode, 'color': 0xFFFFA726},
    {'name': 'Translation', 'icon': Icons.translate, 'color': 0xFF26A69A},
  ];

  List<Map<String, dynamic>> courses = [
    {'name': 'Japanese', 'flag': 'assets/japan_flag.png'},
    {'name': 'English', 'flag': 'assets/us_flag.png'},
    {'name': 'Spanish', 'flag': 'assets/spain_flag.png'},
  ];

  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide();
    });
    _filteredCourses = courses; // Semua kursus menjadi daftar default
    _translatedGreeting = 'Hello, ${widget.username}!'; // Gunakan username
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
        _startAutoSlide();
      }
    });
  }

  int _getRealIndex(int index) => index % _imagePaths.length;

  Future<void> _translateUI(String targetLang) async {
    try {
      final hello = await translator.translate('Hello',
          to: targetLang); 
      final categories =
          await translator.translate('Categories', to: targetLang);
      final courses = await translator
          .translate('What do you want to learn today?', to: targetLang);
      final noCourses =
          await translator.translate('No courses found.', to: targetLang);
      final searchPlaceholder =
          await translator.translate('Search Courses', to: targetLang);

      // Terjemahkan kategori
      final translatedCategories =
          await Future.wait(this.categories.map((category) async {
        final translatedName =
            await translator.translate(category['name'], to: targetLang);
        print(
            'Translated ${category['name']} to ${translatedName.text}'); // Debug log
        return {...category, 'name': translatedName.text};
      }));

      final translatedCourses =
          await Future.wait(this.courses.map((course) async {
        final translatedName =
            await translator.translate(course['name']!, to: targetLang);
        return {'name': translatedName.text, 'flag': course['flag']};
      }));

      setState(() {
        _translatedCategories = categories.text;
        _translatedCourses = courses.text;
        _translatedNoCourses = noCourses.text;
        _translatedSearchPlaceholder =
            searchPlaceholder.text;
        this.categories = translatedCategories;
        this.courses = translatedCourses;
        _filteredCourses = translatedCourses;
        _translatedGreeting =
            '${hello.text}, ${widget.username}!';
      });
    } catch (e) {
      print("Translation error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF4B61DD),
      padding: const EdgeInsets.only(top: 45, bottom: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 20),
          Text(
            _translatedGreeting,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Polylingo',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.g_translate, color: Colors.white),
          onSelected: (String value) {
            _translateUI(value); 
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'es', child: Text('Spanish')),
              const PopupMenuItem(value: 'id', child: Text('Indonesian')),
              const PopupMenuItem(value: 'ja', child: Text('Japanese')),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _filteredCourses = courses
              .where((course) =>
                  course['name']!.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
      decoration: InputDecoration(
        hintText:
            _translatedSearchPlaceholder, // Gunakan placeholder yang sudah diterjemahkan
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageCarousel(),
              const SizedBox(height: 30),
              _buildCategoriesSection(),
              const SizedBox(height: 30),
              _buildCoursesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) =>
                  _buildImageCard(_getRealIndex(index)),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imagePaths.map((url) {
              int index = _imagePaths.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage % _imagePaths.length == index
                      ? const Color(0xFF4B61DD)
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemCount: categories.length, // Gunakan categories global
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCircle(
          name: category['name'],
          icon: category['icon'],
          color: Color(category['color']),
        );
      },
    );
  }

  Widget _buildCategoryCircle(
      {required String name, required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: () => print('$name selected'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 55, // Ukuran lingkaran
            width: 55,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child:
                Icon(icon, size: 25, color: color), // Ikon di dalam lingkaran
          ),
          const SizedBox(height: 5),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11, // Ukuran teks lebih kecil
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1, // Batasi teks ke satu baris
            overflow: TextOverflow
                .ellipsis, // Tambahkan "..." jika teks terlalu panjang
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _translatedCourses,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B61DD)),
        ),
        const SizedBox(height: 10),
        _filteredCourses.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _translatedNoCourses,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : Column(
                children: _filteredCourses.map((course) {
                  return Column(
                    children: [
                      _buildCourseItem(
                          context, course['name']!, course['flag']!),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildImageCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(_imagePaths[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () => print('$title category selected'),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Text(
              capitalize(title), // Gunakan fungsi capitalize
              style: TextStyle(
                  fontSize: 18, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(
      BuildContext context, String language, String flagPath) {
    return GestureDetector(
      onTap: () {
        if (language == 'Japanese') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JapaneseCoursePage()),
          );
        } else if (language == 'English') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EnglishCoursePage()),
          );
        } else if (language == 'Spanish') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SpanishCoursePage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFF4B61DD), Color(0xFF7386FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(flagPath),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
