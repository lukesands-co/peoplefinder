class EnforceMembershipIntegrity < ActiveRecord::Migration
  def change
    change_column_null :memberships, :person_id, false
    change_column_null :memberships, :group_id, false
    add_foreign_key :memberships, :people
    add_foreign_key :memberships, :groups
  end
end
