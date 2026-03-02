import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';

class PromotionCodesScreen extends StatelessWidget {
  const PromotionCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Promosyon Kodlarım')),
      body: state.campaigns.isEmpty
          ? const Center(child: Text('Aktif promosyon kodu bulunmuyor.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = state.campaigns[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              campaign.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEA004B),
                              ),
                            ),
                            const Icon(Icons.local_offer,
                                color: Color(0xFFEA004B)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(campaign.description),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                campaign.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: campaign.code));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Kupon kodu kopyalandı!'),
                                      duration: Duration(seconds: 1),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: const [
                                    Icon(Icons.copy,
                                        size: 18, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('Kopyala',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (100 * index).ms).slideX();
              },
            ),
    );
  }
}
