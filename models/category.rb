Category.class_eval do

  has_many :subcategories_metas, class_name: 'Category', foreign_key: 'parent_category_id'
  
  attr_accessor :subcategory_metas
end