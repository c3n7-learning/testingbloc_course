import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/dialogs/generic_dialog.dart';
import 'package:testingbloc_course/dialogs/loading_screen.dart';
import 'package:testingbloc_course/models.dart';
import 'package:testingbloc_course/strings.dart';
import 'package:testingbloc_course/views/iterable_list_view.dart';
import 'package:testingbloc_course/views/login_view.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            // take care of loading screen
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // display possible errors
            if (state.loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }

            // If we are logged in but have no fetched notes
            if (!state.isLoading &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
