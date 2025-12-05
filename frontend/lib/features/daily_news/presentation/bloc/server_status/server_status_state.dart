part of 'server_status_bloc.dart';

abstract class ServerStatusState extends Equatable {
  const ServerStatusState();

  @override
  List<Object> get props => [];
}

class ServerStatusInitial extends ServerStatusState {
  const ServerStatusInitial();
}

class ServerStatusLoading extends ServerStatusState {
  const ServerStatusLoading();
}

class ServerStatusSuccess extends ServerStatusState {
  final String message;
  const ServerStatusSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ServerStatusError extends ServerStatusState {
  final String message;
  const ServerStatusError(this.message);

  @override
  List<Object> get props => [message];
}
