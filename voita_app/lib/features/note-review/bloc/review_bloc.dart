import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final NoteRepositoryImpl _noteRepo = NoteRepositoryImpl();
  ReviewBloc() : super(ReviewInitial()) {
    on<ReviewTerminate>(_onReviewTerminate);
  }

  void _onReviewTerminate (ReviewTerminate event, Emitter<ReviewState> emit) async {
    await _noteRepo.updateNote(event.id, event.header, event.text);
  }
}