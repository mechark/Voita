part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class ReviewTerminate extends ReviewEvent {
  final int id;
  final String header;
  final String text;

  const ReviewTerminate({required this.id, required this.header, required this.text});

  @override
  List<Object> get props => [id, header, text];
}