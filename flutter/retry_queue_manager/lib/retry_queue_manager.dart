library retry_queue_manager;

class QueueManager {
  final dynamic apiHandler;
  static final QueueManager instance = QueueManager();

  QueueManager({this.apiHandler});

  Future<void> processQueue() async {}

  Future<void> clear() async {}

  Future<void> addRequest(dynamic requestData, [dynamic extra]) async {}
}
