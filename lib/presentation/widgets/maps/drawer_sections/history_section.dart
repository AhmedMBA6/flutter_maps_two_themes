import 'package:flutter/material.dart';
import 'section_header.dart';
import 'history_item.dart';
import '../shared_models.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Search History',
            subtitle: '5 recent searches',
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: SamplePlaces.searchHistory.length,
      itemBuilder: (context, index) {
        return HistoryItem(query: SamplePlaces.searchHistory[index]);
      },
    );
  }
}
