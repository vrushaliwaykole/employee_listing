class Employee < ActiveRecord::Base
  
  validates :age, :department, :designation, :email_id, :location, :name,presence: true
  validates :email_id, uniqueness: {case_sensitive: false}
  validates_format_of :email_id, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  attr_accessible :age, :department, :designation, :email_id, :location, :name
end
