library retry_queue_manager;

abstract class ApiQueueHandler {}

class QueueManager {
  final dynamic apiHandler;
  static final QueueManager instance = QueueManager();

  QueueManager({this.apiHandler});

  Future<void> init() async {}
  Future<void> logSavedRequests() async {}
  Future<void> processQueue() async {}
  Future<void> clear() async {}
  Future<void> addRequest(dynamic requestData, [dynamic extra1, dynamic extra2]) async {}
}
