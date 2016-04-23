class Funder < ActiveRecord::Base
  has_many :opportunities
end
