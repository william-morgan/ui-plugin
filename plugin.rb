# name: subcategory_meta
# about: adds extra subcategory information to the category list serializer
# author: william morgan
after_initialize do
  load File.expand_path("../models/category.rb", __FILE__)
  load File.expand_path("../models/category_list.rb", __FILE__)
  load File.expand_path("../serializers/category_detailed_serializer.rb", __FILE__)
end
