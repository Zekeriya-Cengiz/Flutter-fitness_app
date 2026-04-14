import 'package:flutter/material.dart';
import '../../workout/workout_detail_screen.dart';

class WorkoutTab extends StatelessWidget {
  const WorkoutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Antrenmanlar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildWorkoutCard(
                context,
                title: 'Göğüs Antrenmanı',
                duration: '45 dk',
                difficulty: 'Orta',
                image: '',
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              _buildWorkoutCard(
                context,
                title: 'Sırt Antrenmanı',
                duration: '40 dk',
                difficulty: 'Zor',
                image: '',
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              _buildWorkoutCard(
                context,
                title: 'Bacak Antrenmanı',
                duration: '50 dk',
                difficulty: 'Orta',
                image: '',
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 16),
              _buildWorkoutCard(
                context,
                title: 'Omuz Antrenmanı',
                duration: '35 dk',
                difficulty: 'Orta',
                image: '',
                color: Theme.of(context).colorScheme.primary.withBlue(150),
              ),
              const SizedBox(height: 16),
              _buildWorkoutCard(
                context,
                title: 'Kol Antrenmanı',
                duration: '30 dk',
                difficulty: 'Kolay',
                image: '',
                color: Theme.of(context).colorScheme.secondary.withGreen(200),
              ),
              const SizedBox(height: 16),
              _buildWorkoutCard(
                context,
                title: 'Karın Antrenmanı',
                duration: '25 dk',
                difficulty: 'Zor',
                image: '',
                color: Theme.of(context).colorScheme.tertiary.withRed(200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(
    BuildContext context, {
    required String title,
    required String duration,
    required String difficulty,
    required String image,
    required Color color,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetailScreen(
                  title: title,
                  image: image,
                  duration: duration,
                  difficulty: difficulty,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          difficulty,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
