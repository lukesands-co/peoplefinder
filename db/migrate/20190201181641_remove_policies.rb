class RemovePolicies < ActiveRecord::Migration
  def change
  	remove_foreign_key "groups", "policies"
    drop_table "policies"
  end
end
