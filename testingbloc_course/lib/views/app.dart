import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/dialogs/show_auth_error_dialog.dart';
import 'package:testingbloc_course/loading/loading_screen.dart';
import 'package:testingbloc_course/views/login_view.dart';
import 'package:testingbloc_course/views/photo_gallery_view.dart';
import 'package:testingbloc_course/views/register_view.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            }
            if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            }
            if (state is AppStateIsInRegistrationView) {
              return const RegisterView();
            }

            return Container();
          },
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = state.authError;
            if (authError != null) {
              showAuthError(authError: authError, context: context);
            }
          },
        ),
      ),
    );
  }
}
