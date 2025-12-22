import '../models/position_model.dart';

abstract class ReportRepository {
  Future<List<PositionModel>> getPositions();
  Future<void> sendReport(List<PositionModel> items);
}
