import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app/common/myhttp.dart';
import 'package:movie_app/common/utils.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/home/MovieDetailsPage.dart';
import 'package:movie_app/pages/search/search_page.dart';
import 'package:movie_app/widgets/bottom_nav_bar.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: kBackgoundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: kBackgoundColor,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: kBackgoundColor,
          )),
      home: const BottomNavBar(),
      routes: {
        '/search': (context) => const SearchPage(),
        '/movie_details': (context) {
          final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
          return MovieDetailsPage(movie: movie);
        },
        // Adicione outras rotas conforme necessário
      },
    );
  }
}
