User.class_eval do
  
  attr_accessor :profile_fields
  
  def profile_fields
    profile_fields
  end
  private
    def profile_fields
      @profile_fields[:join_date]  = User.where(:id=>2).pluck("to_char(created_at, 'Mon YYYY') AS created_at").first
      @profile_fields[:post_count] = Post.where("user_id='?' AND hidden = FALSE", 2).count
      @profile_fields[:reputation] = User.where(:id=>2).joins(:user_stat).pluck(:likes_given).first
      @profile_fields[:rep_power]  =  User.where(:id=>2).pluck("date_part('day',now()- created_at)").first.to_i
    end
end
