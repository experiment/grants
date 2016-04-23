class Opportunity < ActiveRecord::Base
  validates_presence_of :name, :foreign_key, :funder_id, :first_source_id
  validates_uniqueness_of :foreign_key, scope: :funder_id

  belongs_to :funder
  belongs_to :first_source, foreign_key: 'first_source_id', class_name: 'Source'
end
