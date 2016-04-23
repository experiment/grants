class AddSearchToOpportunities < ActiveRecord::Migration
  def up
    # Create the search vector column
    add_column :opportunities, :search_vector, 'tsvector'

    # Create the gin index on the search vector
    execute <<-SQL
      CREATE INDEX opportunies_search_idx ON opportunities USING gin(search_vector);
    SQL

    # Trigger to update the vector column when the opportunities table is updated
    execute <<-SQL
      CREATE OR REPLACE FUNCTION fill_search_vector_for_opportunities() RETURNS trigger LANGUAGE plpgsql AS $$
      begin
        new.search_vector :=
           setweight(to_tsvector('pg_catalog.english', coalesce(new.name, '')), 'A') ||
           setweight(to_tsvector('pg_catalog.english', coalesce(new.description, '')), 'B');
        return new;
      end
      $$;

      DROP TRIGGER IF EXISTS opportunies_search_content_trigger ON opportunities;

      CREATE TRIGGER opportunies_search_content_trigger BEFORE INSERT OR UPDATE
      ON opportunities FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_opportunities();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS opportunies_search_content_trigger ON opportunities;
      DROP FUNCTION IF EXISTS fill_search_vector_for_opportunities();
    SQL

    remove_column :opportunities, :search_vector
  end
end
