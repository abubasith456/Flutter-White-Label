import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class OnboardingEvent {}

class PageChanged extends OnboardingEvent {
  final int index;
  PageChanged(this.index);
}

class NextPage extends OnboardingEvent {}

// State
class OnboardingState {
  final int pageIndex;
  final bool isLastPage;

  OnboardingState({required this.pageIndex, required this.isLastPage});

  OnboardingState copyWith({int? pageIndex, bool? isLastPage}) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

// Bloc
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CarouselController carouselController =
      CarouselController(); // Move here
  final CarouselSliderController slider = CarouselSliderController();

  OnboardingBloc() : super(OnboardingState(pageIndex: 0, isLastPage: false)) {
    on<PageChanged>((event, emit) {
      emit(
        state.copyWith(pageIndex: event.index, isLastPage: event.index == 2),
      );
    });

    on<NextPage>((event, emit) {
      final newIndex = state.pageIndex + 1;
      if (newIndex < 3) {
        slider.animateToPage(newIndex); // Animate smoothly
        emit(state.copyWith(pageIndex: newIndex, isLastPage: newIndex == 2));
      }
    });
  }
}
