class Post < ApplicationRecord
  belongs_to :user

  validates :referral_link, presence: true
end
