class DefaultMembershipSubscriptionToFalse < ActiveRecord::Migration
  def change
    change_column_default :memberships, :subscribed, false
  end
end
