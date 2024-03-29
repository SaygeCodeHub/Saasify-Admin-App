abstract class CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Map addCategoryMap;

  AddCategory({required this.addCategoryMap});
}

class FetchCategories extends CategoryEvent {}
