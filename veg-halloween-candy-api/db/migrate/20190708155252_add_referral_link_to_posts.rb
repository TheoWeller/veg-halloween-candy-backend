class AddReferralLinkToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :referral_link, :string
  end
end
