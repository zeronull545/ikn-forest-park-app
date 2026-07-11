import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/posts_provider.dart';
import 'providers/parks_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/parks/parks_list_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authProvider = AuthProvider();
  await authProvider.tryAutoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProxyProvider<AuthProvider, PostsProvider>(
          create: (ctx) => PostsProvider('', []),
          update: (ctx, auth, previousPosts) => PostsProvider(
            auth.token ?? '',
            previousPosts == null ? [] : previousPosts.posts,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ParksProvider>(
          create: (ctx) => ParksProvider('', []),
          update: (ctx, auth, previousParks) => ParksProvider(
            auth.token ?? '',
            previousParks == null ? [] : previousParks.parks,
          ),
        ),
      ],
      child: const IKNForestParksApp(),
    ),
  );
}

class IKNForestParksApp extends StatelessWidget {
  const IKNForestParksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => MaterialApp(
        title: 'IKN Forest Parks',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.natureTheme,
        home: auth.isAuth 
            ? const HomeScreen() 
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState == ConnectionState.waiting
                        ? const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(
                                color: Colors.forestGreen, // Will map to primary theme
                              ),
                            ),
                          )
                        : const LoginScreen(),
              ),
        routes: {
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const RegisterScreen(),
          '/home': (ctx) => const HomeScreen(),
          '/parks': (ctx) => const ParksListScreen(),
          '/profile': (ctx) => const ProfileScreen(),
        },
      ),
    );
  }
}
