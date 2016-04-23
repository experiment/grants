class Opportunity < ActiveRecord::Base
  include PgSearch

  validates_presence_of :name, :foreign_key, :funder_id, :first_source_id
  validates_uniqueness_of :foreign_key, scope: :funder_id

  belongs_to :funder
  belongs_to :first_source, foreign_key: 'first_source_id', class_name: 'Source'

  pg_search_scope :search,
    against: { title: 'A', description: 'B' },
    using: {
      tsearch: {
        dictionary: 'english',
        tsvector_column: 'search_vector'
      }
    }
end
