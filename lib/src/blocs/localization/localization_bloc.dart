import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'localization_event.dart';
part 'localization_state.dart';
part 'localization_bloc.freezed.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const _Initial()) {
    on<LocalizationEvent>((event, emit) {
      emit(const _Initial());
      emit(const _Success());
    });
  }
}

final LocalizationBloc localizationBloc = LocalizationBloc();
