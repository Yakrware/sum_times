class CreatePluckFunctionAndIndex < ActiveRecord::Migration
  def change    
    reversible do |dir|
      dir.up do
        execute <<-SQL 
                  CREATE OR REPLACE FUNCTION pluck_from_json_array(_j json, _k varchar)
                  RETURNS text[] AS
                  $$
                  SELECT array_agg(elem->>_k)
                  FROM json_array_elements(_j) AS elem
                  $$ LANGUAGE sql IMMUTABLE;
                SQL
        execute "CREATE INDEX workdays_hours_type ON workdays USING GIN ( pluck_from_json_array(hours, 'type') )"
      end
      dir.down do
        execute "DROP INDEX workdays_hours_type"
        execute "DROP FUNCTION pluck_from_json_array(_j json, _k varchar)"
      end
    end
  end
end
