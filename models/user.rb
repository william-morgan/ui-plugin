User.class_eval do
  def profile_Fields
    profile_fields
  end
  private
    def profile_fields
      @fields[:join_date]  = User.where(:id=>2).pluck("to_char(created_at, 'Mon YYYY') AS created_at").first
      @fields[:post_count] = Post.where("user_id='?' AND hidden = FALSE", 2).count
      @fields[:reputation] = User.where(:id=>2).joins(:user_stat).pluck(:likes_given).first
    end
end
