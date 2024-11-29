import 'package:flutter/material.dart';
import 'spanish_course_page.dart'; // Import SpainCourseScreen
import 'japanese_course_page.dart'; // Import JapanCourseScreen
import 'english_course_page.dart'; // Import EnglishCourseScreen


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B61DD),
      body: Padding(
        padding: const EdgeInsets.only(top: 45, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Polylingo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.g_translate, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Courses',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search here...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Add course items for each language
            _buildCourseItem(context, 'Japanese', 'assets/japan_flag.png'),
            const SizedBox(height: 15),
            _buildCourseItem(context, 'English', 'assets/us_flag.png'), // Update flag asset for English
            const SizedBox(height: 15),
            _buildCourseItem(context, 'Spanish', 'assets/spain_flag.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, String language, String flagPath) {
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(flagPath),
            ),
            const SizedBox(width: 15),
            Text(
              language,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
