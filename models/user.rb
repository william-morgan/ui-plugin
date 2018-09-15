User.class_eval do
  attr_accessor :user_post_data
  
  def user_post_data
    sql = (<<~SQL).freeze
      SELECT likes_received AS reputation, 
             to_char(users.created_at, 'Mon YYYY') AS join_date, 
             post_count AS total_posts, 
             date_part('day',now()- created_at) AS rep_power 
      FROM users, user_stats WHERE users.id=user_stats.user_id AND users.id=:user_id LIMIT 1
    SQL
    DB.query(sql, user_id: id).map{ 
      |q| {
           total_posts: q.total_posts, 
           rep_power: q.rep_power, 
           join_date: q.join_date, 
           reputation: q.reputation}
      }[0]
  end
end
