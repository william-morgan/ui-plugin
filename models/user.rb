User.class_eval do
  
  attr_accessor :profile_fields
  
  def profile_fields
    profile_fields
  end
  private
    def profile_fields
      @profile_fields[:join_date]  = User.where(id: id).pluck("to_char(created_at, 'Mon YYYY') AS created_at").first
      @profile_fields[:post_count] = Post.where(user_id: id, hidden: false).count
      @profile_fields[:reputation] = UserAction.where(user_id: id, action_type: UserAction::LIKE).count
      @profile_fields[:rep_power]  =  User.where(:id=>2).pluck("date_part('day',now()- created_at)").first.to_i
    end
end
