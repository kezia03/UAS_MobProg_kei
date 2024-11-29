import 'package:flutter/material.dart';
import 'dart:math';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  // A list of questions with related random answers
  final List<Map<String, dynamic>> faqData = [
    {
      'question': 'What are the requirements needed?',
      'answers': [
        'You need a stable internet connection.',
        'A smartphone or computer is required.',
        'Basic knowledge of English is recommended.'
      ]
    },
    {
      'question': 'Will I be able to learn offline?',
      'answers': [
        'Yes, you can download lessons for offline use.',
        'Offline mode is available with a subscription.',
        'Certain features may require an internet connection.'
      ]
    },
    {
      'question': 'What course of language does this application recommend?',
      'answers': [
        'We recommend starting with the Beginner’s course.',
        'Intermediate courses are available if you have prior experience.',
        'Advanced courses focus on fluency and real-life scenarios.'
      ]
    },
    {
      'question': 'Is it free or a Subscription application?',
      'answers': [
        'It’s free with optional subscription for premium features.',
        'Some features are accessible through a one-time payment.',
        'You can access the full course with a monthly subscription.'
      ]
    },
    {
      'question': 'Do we have a Discount code?',
      'answers': [
        'Check our social media for the latest discount codes.',
        'Discount codes are occasionally sent via email newsletters.',
        'Special offers are available during the holiday season.'
      ]
    },
    {
      'question': 'Will I be able to have a meeting with the teachers?',
      'answers': [
        'Yes, scheduled meetings with teachers are available for premium users.',
        'You can book a one-on-one session for extra guidance.',
        'Teacher availability depends on your course subscription.'
      ]
    },
    {
      'question': 'How many courses does this application have?',
      'answers': [
        'We currently offer over 20 language courses.',
        'New courses are added frequently based on demand.',
        'Specialized courses for business and travel are also available.'
      ]
    },
  ];

  // Helper method to generate a random answer
  String getRandomAnswer(List<String> answers) {
    final random = Random();
    return answers[random.nextInt(answers.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text(
          'FAQ',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: faqData.map((faq) {
            return _buildFAQItem(faq['question'], faq['answers']);
          }).toList(),
        ),
      ),
    );
  }

  // Helper method to create FAQ items with a dropdown for answers
  Widget _buildFAQItem(String question, List<String> answers) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B61DD),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              getRandomAnswer(answers), // Display a random answer
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
