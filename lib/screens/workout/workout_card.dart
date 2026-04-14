import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import 'workout_detail_screen.dart';

class WorkoutCard extends StatefulWidget {
  final String title;
  final String duration;
  final String difficulty;
  final Color color;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.color,
  });

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shadowColor: widget.color.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(
                title: widget.title,
                image: '',
                duration: widget.duration,
                difficulty: widget.difficulty,
              ),
            ),
          ).then((_) => _checkFavoriteStatus());
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.fitness_center,
                  size: 120,
                  color: widget.color.withOpacity(0.1),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getWorkoutIcon(widget.title),
                              color: widget.color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          if (!_isLoading)
                            IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite
                                    ? const Color(0xFFFF2E63)
                                    : Colors.white,
                              ),
                              onPressed: _toggleFavorite,
                            ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _buildInfoChip(
                            context,
                            icon: Icons.timer_outlined,
                            label: widget.duration,
                            color: widget.color,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            context,
                            icon: Icons.fitness_center,
                            label: widget.difficulty,
                            color: widget.color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  IconData _getWorkoutIcon(String title) {
    final lowercaseTitle = title.toLowerCase();
    if (lowercaseTitle.contains('göğüs')) {
      return Icons.accessibility_new;
    } else if (lowercaseTitle.contains('sırt')) {
      return Icons.airline_seat_flat;
    } else if (lowercaseTitle.contains('bacak')) {
      return Icons.directions_walk;
    } else if (lowercaseTitle.contains('omuz')) {
      return Icons.sports_gymnastics;
    } else if (lowercaseTitle.contains('kol')) {
      return Icons.sports_martial_arts;
    } else if (lowercaseTitle.contains('karın')) {
      return Icons.fitness_center;
    }
    return Icons.fitness_center;
  }
}
