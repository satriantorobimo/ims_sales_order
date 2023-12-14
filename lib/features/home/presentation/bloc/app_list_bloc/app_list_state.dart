import 'package:equatable/equatable.dart';
import 'package:sales_order/features/home/data/app_list_response_model.dart';

abstract class AppListState extends Equatable {
  const AppListState();

  @override
  List<Object> get props => [];
}

class AppListInitial extends AppListState {}

class AppListLoading extends AppListState {}

class AppListLoaded extends AppListState {
  const AppListLoaded({required this.appListResponseModel});
  final AppListResponseModel appListResponseModel;

  @override
  List<Object> get props => [appListResponseModel];
}

class AppListError extends AppListState {
  const AppListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AppListException extends AppListState {
  const AppListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
