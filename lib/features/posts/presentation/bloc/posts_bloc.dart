import 'package:flutter_bloc/flutter_bloc.dart';

class PostsBloc extends Bloc<PostsEvents, PostsState> {
  PostsBloc() : super(PostsState()) {}
}
