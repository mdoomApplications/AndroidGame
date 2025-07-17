import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_theme.dart';

class HatchingScreen extends StatefulWidget {
  @override
  _HatchingScreenState createState() => _HatchingScreenState();
}

class _HatchingScreenState extends State<HatchingScreen> 
    with TickerProviderStateMixin {
  late AnimationController _eggController;
  late AnimationController _pulseController;
  late Animation<double> _eggAnimation;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _eggController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _eggAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _eggController,
      curve: Curves.elasticOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _eggController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _eggController.dispose();
    _pulseController.dispose();
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: EdgeInsets.all(20),
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🐉 ${gameProvider.dragon?.name ?? 'DRÁČEK'} SE LÍHNE 🐉',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: 40),
                          
                          // Animované vejce
                          GestureDetector(
                            onTap: () => _hatchDragon(context, gameProvider),
                            child: AnimatedBuilder(
                              animation: Listenable.merge([_eggAnimation, _pulseAnimation]),
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Transform.rotate(
                                    angle: _eggAnimation.value * 0.1,
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.amber.withOpacity(0.4),
                                            blurRadius: 25,
                                            spreadRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '🥚',
                                        style: TextStyle(fontSize: 100),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          SizedBox(height: 40),
                          
                          // Odpočítávání
                          if (gameProvider.hatchCountdown > 0)
                            Column(
                              children: [
                                Text(
                                  '${gameProvider.hatchCountdown}',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryRed,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Čekej na vylíhnutí...',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                Text(
                                  'KLIKNI!',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Klikni na vejce pro vylíhnutí!',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _hatchDragon(BuildContext context, GameProvider gameProvider) {
    if (gameProvider.isHatching || gameProvider.hatchCountdown > 0) return;
    
    gameProvider.hatchDragon();
  }
}