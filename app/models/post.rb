class Post < ActiveRecord::Base
  attr_accessible :post_type, :title, :body, :workout_type, :workout_date, :workout_time, :miles, :hours, :minutes, :seconds, :url, :user_id

  validates :title, presence: true
  validates :user, presence: true

  belongs_to :user, inverse_of: :posts
  has_many :user_post_likes, inverse_of: :post

  has_many :comments, inverse_of: :post

  def likes
    self.user_post_likes.sum(:value)
  end

  def comments_by_parent
    comments_by_parent = Hash.new { |hash, key| hash[key] = [] }

    comments.each do |comment|
      comments_by_parent[comment.parent_comment_id] << comment
    end

    comments_by_parent
  end
end
