import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stat_progress_bar.dart';
import '../widgets/animated_dragon.dart';

class MainGameScreen extends StatefulWidget {
  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> 
    with TickerProviderStateMixin {
  late AnimationController _dragonController;
  late Animation<double> _dragonAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _dragonController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _dragonAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _dragonController,
      curve: Curves.easeInOut,
    ));
    
    _dragonController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _dragonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              final dragon = gameProvider.dragon!;
              
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Hlavička
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '🐉 ${dragon.name} 🐉',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Info panel
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfoChip(
                                  icon: Icons.cake,
                                  label: 'Věk',
                                  value: '${dragon.age} dní',
                                  color: AppTheme.primaryPurple,
                                ),
                                _buildInfoChip(
                                  icon: Icons.monetization_on,
                                  label: 'Mince',
                                  value: '${dragon.coins}',
                                  color: AppTheme.primaryOrange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Statistiky
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            StatProgressBar(
                              icon: Icons.restaurant,
                              label: 'HLAD',
                              value: dragon.hunger,
                              color: AppTheme.primaryRed,
                              maxValue: 100,
                            ),
                            SizedBox(height: 16),
                            StatProgressBar(
                              icon: Icons.water_drop,
                              label: 'ŽÍZEŇ',
                              value: dragon.thirst,
                              color: AppTheme.primaryBlue,
                              maxValue: 100,
                            ),
                            SizedBox(height: 16),
                            StatProgressBar(
                              icon: Icons.sentiment_satisfied,
                              label: 'NÁLADA',
                              value: dragon.mood,
                              color: AppTheme.primaryGreen,
                              maxValue: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Animovaný dráček
                    GestureDetector(
                      onTap: () => _petDragon(context, gameProvider),
                      child: AnimatedBuilder(
                        animation: _dragonAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _dragonAnimation.value),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Text(
                                dragon.dragonEmoji,
                                style: TextStyle(fontSize: 120),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Akce
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildActionButton(
                              context: context,
                              icon: Icons.calculate,
                              label: 'POČÍTÁNÍ (+2🪙)',
                              color: AppTheme.primaryPurple,
                              onPressed: () => _playMath(context, gameProvider),
                            ),
                            SizedBox(height: 12),
                            _buildActionButton(
                              context: context,
                              icon: Icons.restaurant,
                              label: 'NAKRMIT (-8🪙)',
                              color: AppTheme.primaryGreen,
                              onPressed: dragon.coins >= 8 
                                ? () => _feedDragon(context, gameProvider)
                                : null,
                            ),
                            SizedBox(height: 12),
                            _buildActionButton(
                              context: context,
                              icon: Icons.water_drop,
                              label: 'NAPOJIT (-5🪙)',
                              color: AppTheme.primaryBlue,
                              onPressed: dragon.coins >= 5 
                                ? () => _giveDrink(context, gameProvider)
                                : null,
                            ),
                            SizedBox(height: 12),
                            _buildActionButton(
                              context: context,
                              icon: Icons.refresh,
                              label: 'RESTART',
                              color: AppTheme.primaryRed,
                              onPressed: () => _showRestartDialog(context, gameProvider),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? color : Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _petDragon(BuildContext context, GameProvider gameProvider) {
    gameProvider.petDragon();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🐉 Dráček je šťastný!'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _feedDragon(BuildContext context, GameProvider gameProvider) {
    gameProvider.feedDragon();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🍖 NAKRMIL JSI DRÁČKA!'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _giveDrink(BuildContext context, GameProvider gameProvider) {
    gameProvider.giveDrink();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💧 NAPOJIL JSI DRÁČKA!'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _playMath(BuildContext context, GameProvider gameProvider) {
    final a = Random().nextInt(10) + 1;
    final b = Random().nextInt(10) + 1;
    final correct = a + b;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🧮 POČÍTÁNÍ!'),
        content: Text('$a + $b = ?', style: TextStyle(fontSize: 24)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ZRUŠIT'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAnswerDialog(context, correct, gameProvider);
            },
            child: Text('ODPOVĚDĚT'),
          ),
        ],
      ),
    );
  }

  void _showAnswerDialog(BuildContext context, int correct, GameProvider gameProvider) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tvá odpověď:'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Zadej číslo',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ZRUŠIT'),
          ),
          TextButton(
            onPressed: () {
              final answer = int.tryParse(controller.text);
              Navigator.pop(context);
              
              if (answer == correct) {
                gameProvider.addCoinsForCorrectAnswer();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🎉 SPRÁVNĚ! +2 MINCE!'),
                    backgroundColor: AppTheme.primaryGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                gameProvider.penalizeWrongAnswer();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ ŠPATNĚ! Správně: $correct'),
                    backgroundColor: AppTheme.primaryRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text('POTVRDIT'),
          ),
        ],
      ),
    );
  }

  void _showRestartDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🔄 RESTART HRY'),
        content: Text('Opravdu chceš začít znovu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('NE'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              gameProvider.resetGame();
            },
            child: Text('ANO'),
          ),
        ],
      ),
    );
  }
}