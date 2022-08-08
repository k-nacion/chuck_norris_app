import 'package:chuck_norris_app/chuck_norris/presentation/bloc/chuck_norris/chuck_norris_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider<ChuckNorrisBloc>(
          create: (context) => ChuckNorrisBloc(getRandomJokeUseCase: null),
        ),
      ],
      child: BlocBuilder<ChuckNorrisBloc, ChuckNorrisState>(
        builder: (context, state) {
          return Container();
        },
      ),
    ));
  }
}
