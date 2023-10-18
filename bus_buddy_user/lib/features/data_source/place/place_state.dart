import 'package:equatable/equatable.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object?> get props => [];
}

class PlaceIdleState extends PlaceState {}
