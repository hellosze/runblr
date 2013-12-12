class UserLike < ActiveRecord::Base
  attr_accessible :value, :user_id
  
  belongs_to :user, inverse_of: :user_likes
  belongs_to :post, inverse_of: :user_likesc
end