CategoryList.class_eval do
  def find_categories
    find_categories
  end
  private
    def find_categories
      @categories = Category
                        .includes(:featured_users, :topic_only_relative_url, subcategories: [:topic_only_relative_url, :featured_users])
                        .secured(@guardian)

      if @options[:parent_category_id].present?
        @categories = @categories.where('categories.parent_category_id = ?', @options[:parent_category_id].to_i)
      end

      if SiteSetting.fixed_category_positions
        @categories = @categories.order('position ASC').order('id ASC')
      else
        @categories = @categories.order('COALESCE(categories.posts_week, 0) DESC')
                                 .order('COALESCE(categories.posts_month, 0) DESC')
                                 .order('COALESCE(categories.posts_year, 0) DESC')
                                 .order('id ASC')
      end

      if latest_post_only?
        @categories  = @categories.includes(:latest_post => {:topic => :last_poster} )
      end

      @categories = @categories.to_a
      if @options[:parent_category_id].blank?
        subcategories = {}
        subcategories_metas = {}
        to_delete = Set.new
        @categories.each do |c|
          if c.parent_category_id.present?
            subcategories[c.parent_category_id] ||= []
            subcategories_metas[c.parent_category_id] ||= []

            subcategories[c.parent_category_id] << c.id
            subcategories_meta = {}
            last_topic=Topic.where(:category_id=>c.id,:visible=>true, :archived=>false, :closed=>false).order("updated_at DESC").limit(1)
            if last_topic.size > 0
              #dont instantiate hash unless there's a subcategory topic
              subcategories_meta[:category_id] = c.id
              subcategories_meta[:category_name] = c.name
              subcategories_meta[:category_topic_count] = c.topic_count
              subcategories_meta[:category_post_count] = c.post_count
              subcategories_meta[:category_slug] = c.slug
              subcategories_meta[:last_post_topic_id] = last_topic.pluck(:id)[0]
              subcategories_meta[:last_post_topic_title] = last_topic.pluck(:title)[0]
              subcategories_meta[:last_post_topic_slug] = last_topic.pluck(:slug)[0]
              subcategories_meta[:last_post_topic_highest_post_number] = last_topic.pluck(:highest_post_number)[0]
              #last post info
              last_post = Post.where(:topic_id=>subcategories_meta[:last_post_topic_id],:hidden=>false, :deleted_at=>[nil]).order("created_at DESC").limit(1)
              subcategories_meta[:last_post_created_at] = last_post.pluck(:created_at)[0]
              subcategories_meta[:last_post_user_id] = last_post.pluck(:user_id)[0]
              #last post user info
              last_user = User.where("id=?", subcategories_meta[:last_post_user_id])
              subcategories_meta[:last_post_username] = last_user.pluck("username")[0]
              subcategories_meta[:last_post_username_lower] = last_user.pluck("username_lower")[0]
              #append to subcategories_meta list
              subcategories_metas[c.parent_category_id] << subcategories_meta
            end
            to_delete << c
          end
        end

        if subcategories.present?
          @categories.each do |c|
            c.subcategory_ids = subcategories[c.id]
            c.subcategory_metas = subcategories_metas[c.id]
          end
          @categories.delete_if {|c| to_delete.include?(c) }
        end
      end

      if latest_post_only?
        @categories = @categories.where('categories.parent_category_id = ?', @options[:parent_category_id].to_i)
        @all_topics = []
        @categories.each do |c|
          if c.latest_post && c.latest_post.topic && @guardian.can_see?(c.latest_post.topic)
            c.displayable_topics = [c.latest_post.topic]
            topic = c.latest_post.topic
            topic.include_last_poster = true # hint for serialization
            @all_topics << topic
          end
        end
      end

      if @topics_by_category_id
        @categories.each do |c|
          topics_in_cat = @topics_by_category_id[c.id]
          if topics_in_cat.present?
            c.displayable_topics = []
            topics_in_cat.each do |topic_id|
              topic = @topics_by_id[topic_id]
              if topic.present? && @guardian.can_see?(topic)
                # topic.category is very slow under rails 4.2
                topic.association(:category).target = c
                c.displayable_topics << topic
              end
            end
          end
        end
      end
    end
end