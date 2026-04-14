import 'package:flutter/material.dart';
import '../../services/database_helper.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String title;
  final String image;
  final String duration;
  final String difficulty;

  const WorkoutDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.duration,
    required this.difficulty,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final _databaseHelper = DatabaseHelper.instance;
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    setState(() => _isLoading = true);
    try {
      final isFavorite = await _databaseHelper.isWorkoutFavorite(
          1, widget.title); // TODO: Gerçek kullanıcı ID'sini kullan
      setState(() {
        _isFavorite = isFavorite;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favori durumu kontrol edilirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await _databaseHelper.removeFavoriteWorkout(
            1, widget.title); // TODO: Gerçek kullanıcı ID'sini kullan
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.title} favorilerden kaldırıldı'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _databaseHelper.addFavoriteWorkout(
            1, widget.title); // TODO: Gerçek kullanıcı ID'sini kullan
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.title} favorilere eklendi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      setState(() => _isFavorite = !_isFavorite);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('İşlem sırasında bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<String> _getMuscleGroups() {
    final title = widget.title.toLowerCase();
    if (title.contains('göğüs')) {
      return ['Göğüs', 'Ön Omuz', 'Triceps'];
    } else if (title.contains('sırt')) {
      return ['Sırt', 'Arka Omuz', 'Biceps'];
    } else if (title.contains('bacak')) {
      return ['Quadriceps', 'Hamstring', 'Calf'];
    }
    return ['Tüm Vücut'];
  }

  List<String> _getExercises() {
    final title = widget.title.toLowerCase();
    if (title.contains('göğüs')) {
      return [
        'Bench Press',
        'Incline Dumbbell Press',
        'Chest Dips',
        'Cable Flyes',
      ];
    } else if (title.contains('sırt')) {
      return [
        'Pull-ups',
        'Bent Over Rows',
        'Lat Pulldowns',
        'Face Pulls',
      ];
    } else if (title.contains('bacak')) {
      return [
        'Squats',
        'Romanian Deadlifts',
        'Leg Press',
        'Calf Raises',
      ];
    }
    return ['Jumping Jacks', 'Push-ups', 'Pull-ups', 'Squats'];
  }

  List<String> _getTips() {
    return [
      'Egzersizler arasında 60-90 saniye dinlenin',
      'Her hareketi kontrollü bir şekilde yapın',
      'Doğru form için aynaya bakarak kontrol edin',
      'Yeterli su tüketmeyi unutmayın',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 120,
                        color: Colors.white24,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (!_isLoading)
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? const Color(0xFFFF2E63) : Colors.white,
                  ),
                  onPressed: _toggleFavorite,
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        icon: Icons.timer,
                        title: 'Süre',
                        value: widget.duration,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        icon: Icons.fitness_center,
                        title: 'Zorluk',
                        value: widget.difficulty,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Çalışan Kas Grupları'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getMuscleGroups().map((muscle) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          muscle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Egzersizler'),
                  const SizedBox(height: 12),
                  ..._getExercises().map(
                    (exercise) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        title: Text(
                          exercise,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onTap: () {
                          // TODO: Egzersiz detaylarını göster
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'İpuçları'),
                  const SizedBox(height: 12),
                  ..._getTips().map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      // TODO: Antrenmanı başlat
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Antrenmanı Başlat'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
