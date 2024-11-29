import 'package:flutter/material.dart';
import 'package:polylingo/screens/input_testi_screen.dart';

// A model for a testimony
class Testimony {
  final String name;
  final String content;

  Testimony({required this.name, required this.content});
}

class TestimonyScreen extends StatefulWidget {
  const TestimonyScreen({super.key});

  @override
  _TestimonyScreenState createState() => _TestimonyScreenState();
}

class _TestimonyScreenState extends State<TestimonyScreen> {
  // List to store user testimonies
  List<Testimony> _testimonies = [];

  // Method to add a new testimony
  void _addTestimony(String name, String content) {
    setState(() {
      _testimonies.add(Testimony(name: name, content: content));
    });
  }

  // Initialize some random testimonies
  @override
  void initState() {
    super.initState();
    _testimonies = [
      Testimony(
        name: "John Doe",
        content: "This is a great service. It really helped me improve my skills and knowledge!",
      ),
      Testimony(
        name: "Jane Smith",
        content: "I love this app! It's so easy to use and very effective in teaching.",
      ),
      Testimony(
        name: "David Wilson",
        content: "Amazing experience! The lessons are well-structured, and I feel much more confident now.",
      ),
      Testimony(
        name: "Emily Brown",
        content: "Highly recommend! The content is diverse and keeps me engaged throughout.",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text(
          'Testimony',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.g_translate, color: Colors.white),
            onPressed: () {
              // Implement language switch functionality if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display the list of testimonies
          Expanded(
            child: ListView.builder(
              itemCount: _testimonies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E4FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _testimonies[index].name, // Changed to name
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B61DD),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(_testimonies[index].content),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Testimony Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to InputTestiScreen and wait for the result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputTestiScreen(),
                  ),
                );

                // Check if the user submitted a testimony
                if (result != null && result is Map<String, String>) {
                  _addTestimony(result['title'] ?? '', result['content'] ?? '');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B61DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Input Testimony',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
