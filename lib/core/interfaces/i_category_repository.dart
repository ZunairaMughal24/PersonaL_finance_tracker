import 'package:montage/models/category_model.dart';

abstract class ICategoryRepository {
  Future<void> init(String userId);
  List<CustomCategory> getAllLocal();
  Future<void> saveLocal(List<CustomCategory> categories);
  Future<List<CustomCategory>> pullFromCloud();
  Future<void> syncToCloud(List<CustomCategory> categories);
  void dispose();
}
