import '../models/position_model.dart';

abstract class ReportRepository {
  Future<Map<String, dynamic>> getData(String userId);
  Future<void> sendReport(List<PositionModel> items, String userId);
}
