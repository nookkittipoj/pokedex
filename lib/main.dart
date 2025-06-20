import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pokedex_clean_architecture/data/interceptors/firebase_performance_interceptor.dart';
import 'package:pokedex_clean_architecture/firebase_options.dart';

import 'data/datasources/pokemon_remote_data_source.dart';
import 'data/interceptors/global_loading_interceptor.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'domain/usecases/get_pokemon_list.dart';
import 'domain/usecases/get_pokemon_detail.dart';
import 'presentation/pages/pokemon_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = Dio()
      ..interceptors.add(FirebasePerformanceInterceptor())
      ..interceptors.add(GlobalLoadingInterceptor(ref));
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
    final remoteDataSource = PokemonRemoteDataSourceImpl(dio);
    final repository = PokemonRepositoryImpl(remoteDataSource);

    final getPokemonList = GetPokemonList(repository);
    final getPokemonDetail = GetPokemonDetail(repository);

    return MaterialApp(
      navigatorObservers: [routeObserver],
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Stack(
        children: [
          PokemonListPage(
            getPokemonList: getPokemonList,
            getPokemonDetail: getPokemonDetail,
          ),
        ],
      ),
    );
  }
}
