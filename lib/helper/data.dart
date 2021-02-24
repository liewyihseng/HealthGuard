import 'package:HealthGuard/model/category_model.dart';

/// Represents the list of countries available above the articles in medical_feed page
List<CategoryModel> getCategories(){
  List<CategoryModel> category = new List<CategoryModel>();
  CategoryModel categoryModel;

  // ///1
  // ///Currently API not working. Try again next time
  // categoryModel = new CategoryModel();
  // categoryModel.categoryCode = "CN";
  // categoryModel.categoryName = "China";
  // categoryModel.imageUrl = "https://images.unsplash.com/photo-1473938718606-f15cdc613d96?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1117&q=80";
  // category.add(categoryModel);

  ///2
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "US";
  categoryModel.categoryName = "United States";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1536439372037-e341d08dedf3?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80";
  category.add(categoryModel);

  ///3
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "IN";
  categoryModel.categoryName = "India";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1051&q=80";
  category.add(categoryModel);

  ///4
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "SG";
  categoryModel.categoryName = "Singapore";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1562300735-b1f7f50e774b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80";
  category.add(categoryModel);

  ///5
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "JP";
  categoryModel.categoryName = "Japan";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1559613966-ddf859988e3b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80";
  category.add(categoryModel);

  ///6
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "KR";
  categoryModel.categoryName = "Korea";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1558042195-88baba548eab?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1189&q=80";
  category.add(categoryModel);

  ///7
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "HK";
  categoryModel.categoryName = "Hong Kong";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1509744113929-e514e3ccf904?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1050&q=80";
  category.add(categoryModel);

  ///8
  categoryModel = new CategoryModel();
  categoryModel.categoryCode = "TW";
  categoryModel.categoryName = "Taiwan";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1470004914212-05527e49370b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=926&q=80";
  category.add(categoryModel);

  return category;
}