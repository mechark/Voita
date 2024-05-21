part of 'review_bloc.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  
  @override
  List<Object> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewFinal extends ReviewState {
  final int id;
  final String header;
  final String text;

  const ReviewFinal({required this.id, required this.header, required this.text});

  @override
  List<Object> get props => [id, header, text];
}

