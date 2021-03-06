# == Schema Information
#
# Table name: permitted_domains
#
#  id         :integer          not null, primary key
#  domain     :string
#  created_at :datetime
#  updated_at :datetime
#

class PermittedDomain < ActiveRecord::Base
  validates :domain, presence: true, uniqueness: true
end
