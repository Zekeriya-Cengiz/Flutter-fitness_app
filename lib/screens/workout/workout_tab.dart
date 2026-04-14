import 'package:flutter/material.dart';
import 'workout_card.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  String _selectedFilter = 'Tümü';

  final List<String> _filters = ['Tümü', 'Tüm Vücut', 'Bölgesel'];

  List<Widget> _getFilteredWorkouts() {
    if (_selectedFilter == 'Tümü') {
      return [
        const WorkoutCard(
          title: 'Göğüs Antrenmanı',
          duration: '45 dk',
          difficulty: 'Orta',
          color: Color(0xFF6C63FF),
        ),
        const WorkoutCard(
          title: 'Sırt Antrenmanı',
          duration: '40 dk',
          difficulty: 'Zor',
          color: Color(0xFF00F5D4),
        ),
        const WorkoutCard(
          title: 'Bacak Antrenmanı',
          duration: '50 dk',
          difficulty: 'Orta',
          color: Color(0xFFFF2E63),
        ),
        const WorkoutCard(
          title: 'Omuz Antrenmanı',
          duration: '35 dk',
          difficulty: 'Orta',
          color: Color(0xFFFFA500),
        ),
        const WorkoutCard(
          title: 'Kol Antrenmanı',
          duration: '30 dk',
          difficulty: 'Kolay',
          color: Color(0xFF00F5D4),
        ),
        const WorkoutCard(
          title: 'Karın Antrenmanı',
          duration: '25 dk',
          difficulty: 'Zor',
          color: Color(0xFFFF2E63),
        ),
      ];
    } else if (_selectedFilter == 'Tüm Vücut') {
      return [
        const WorkoutCard(
          title: 'Göğüs Antrenmanı',
          duration: '45 dk',
          difficulty: 'Orta',
          color: Color(0xFF6C63FF),
        ),
        const WorkoutCard(
          title: 'Sırt Antrenmanı',
          duration: '40 dk',
          difficulty: 'Zor',
          color: Color(0xFF00F5D4),
        ),
        const WorkoutCard(
          title: 'Bacak Antrenmanı',
          duration: '50 dk',
          difficulty: 'Orta',
          color: Color(0xFFFF2E63),
        ),
      ];
    } else {
      return [
        const WorkoutCard(
          title: 'Göğüs Antrenmanı',
          duration: '45 dk',
          difficulty: 'Orta',
          color: Color(0xFF6C63FF),
        ),
        const WorkoutCard(
          title: 'Sırt Antrenmanı',
          duration: '40 dk',
          difficulty: 'Zor',
          color: Color(0xFF00F5D4),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Antrenmanlar'),
            floating: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        avatar: isSelected
                            ? Icon(
                                _getFilterIcon(filter),
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              )
                            : null,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(_getFilteredWorkouts()),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Tümü':
        return Icons.grid_view_rounded;
      case 'Tüm Vücut':
        return Icons.person_outline;
      case 'Bölgesel':
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center;
    }
  }
}
