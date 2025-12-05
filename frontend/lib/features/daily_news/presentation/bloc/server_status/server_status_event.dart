part of 'server_status_bloc.dart';

abstract class ServerStatusEvent extends Equatable {
  const ServerStatusEvent();

  @override
  List<Object> get props => [];
}

class CheckServerStatus extends ServerStatusEvent {
  const CheckServerStatus();
}
