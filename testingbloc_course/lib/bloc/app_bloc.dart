import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandle acceptedLoginHandle;

  AppBloc(
      {required this.loginApi,
      required this.notesApi,
      required this.acceptedLoginHandle})
      : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // start loading
        emit(
          const AppState(
            isLoading: true,
            loginError: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );

        // log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );

    on<LoadNotesAction>((event, emit) async {
      // start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );

      // fetch notes
      final loginHandle = state.loginHandle;
      if (loginHandle != acceptedLoginHandle) {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
        return;
      }

      // We have a valid login handle
      final notes = await notesApi.getNotes(
        loginHandle: loginHandle!,
      );

      emit(
        AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: notes,
        ),
      );
    });
  }
}
