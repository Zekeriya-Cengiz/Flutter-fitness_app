import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../workout/workout_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _favoriteWorkouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteWorkouts();
  }

  Future<void> _loadFavoriteWorkouts() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await _databaseHelper
          .getFavoriteWorkouts(1); // TODO: Gerçek kullanıcı ID'sini kullan
      setState(() {
        _favoriteWorkouts = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favoriler yüklenirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeFromFavorites(String workoutName) async {
    try {
      await _databaseHelper.removeFavoriteWorkout(
          1, workoutName); // TODO: Gerçek kullanıcı ID'sini kullan
      await _loadFavoriteWorkouts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$workoutName favorilerden kaldırıldı'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favorilerden kaldırılırken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getWorkoutDuration(String workoutName) {
    // TODO: Antrenman süresini belirle
    return '30 dk';
  }

  String _getWorkoutDifficulty(String workoutName) {
    // TODO: Antrenman zorluğunu belirle
    return 'Orta';
  }

  Color _getWorkoutColor(String workoutName) {
    // Antrenman türüne göre renk belirle
    if (workoutName.toLowerCase().contains('göğüs')) {
      return Colors.blue;
    } else if (workoutName.toLowerCase().contains('sırt')) {
      return Colors.green;
    } else if (workoutName.toLowerCase().contains('bacak')) {
      return Colors.orange;
    }
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteWorkouts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz favori antrenmanınız yok',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Antrenmanları favorilere ekleyerek burada görüntüleyebilirsiniz',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavoriteWorkouts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favoriteWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = _favoriteWorkouts[index];
                      final workoutName = workout['workoutName'] as String;
                      final workoutColor = _getWorkoutColor(workoutName);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetailScreen(
                                  title: workoutName,
                                  image: '',
                                  duration: _getWorkoutDuration(workoutName),
                                  difficulty:
                                      _getWorkoutDifficulty(workoutName),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  workoutColor.withOpacity(0.7),
                                  workoutColor.withOpacity(0.4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workoutName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text(
                                                _getWorkoutDuration(
                                                    workoutName),
                                              ),
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                            const SizedBox(width: 8),
                                            Chip(
                                              label: Text(
                                                _getWorkoutDifficulty(
                                                    workoutName),
                                              ),
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _removeFromFavorites(workoutName),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
