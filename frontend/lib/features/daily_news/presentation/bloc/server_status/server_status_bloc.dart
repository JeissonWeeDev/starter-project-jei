import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/services/debug_service.dart';
import '../../../domain/usecases/check_server_status.dart';
import '../../../../../core/resources/data_state.dart';

part 'server_status_event.dart';
part 'server_status_state.dart';

class ServerStatusBloc extends Bloc<ServerStatusEvent, ServerStatusState> {
  final CheckServerStatusUseCase _checkServerStatusUseCase;

  ServerStatusBloc(this._checkServerStatusUseCase) : super(const ServerStatusInitial()) {
    DebugService().log('[SERVER STATUS BLOC] ServerStatusBloc instantiated.'); // Replaced print
    on<CheckServerStatus>(onCheckStatus);
  }

  void onCheckStatus(CheckServerStatus event, Emitter<ServerStatusState> emit) async {
    DebugService().log('[SERVER STATUS BLOC] Checking server status...');
    emit(const ServerStatusLoading());
    final dataState = await _checkServerStatusUseCase();

    if (dataState is DataSuccess) {
      DebugService().log('[SERVER STATUS BLOC] Server status: SUCCESS');
      emit(const ServerStatusSuccess('✅ Conexión con servidor local exitosa.'));
    } else {
      DebugService().log('[SERVER STATUS BLOC] Server status: ERROR');
      emit(const ServerStatusError('❌ Error: No se pudo conectar al servidor local. Asegúrate de que el emulador de Firebase está corriendo.'));
    }
  }
}
