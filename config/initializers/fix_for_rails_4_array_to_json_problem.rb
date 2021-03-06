module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn < Column
      module Cast
  	def json_to_string(object)
		  if Hash === object || Array === object
		    ActiveSupport::JSON.encode(object)
		  else
		    object
		  end
		end      	
      end
  	end
  end
end

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      module Quoting
      	# Quotes PostgreSQL-specific data types for SQL input.
        def quote(value, column = nil) #:nodoc:
          return super unless column

          sql_type = type_to_sql(column.type, column.limit, column.precision, column.scale)

          case value
          when Range
            if /range$/ =~ sql_type
              "'#{PostgreSQLColumn.range_to_string(value)}'::#{sql_type}"
            else
              super
            end
          when Array
            case sql_type
            when 'point' then super(PostgreSQLColumn.point_to_string(value))
            when 'json' then super(PostgreSQLColumn.json_to_string(value))
            else
              if column.array
                "'#{PostgreSQLColumn.array_to_string(value, column, self).gsub(/'/, "''")}'"
              else
                super
              end
            end
          when Hash
            case sql_type
            when 'hstore' then super(PostgreSQLColumn.hstore_to_string(value), column)
            when 'json' then super(PostgreSQLColumn.json_to_string(value), column)
            else super
            end
          when IPAddr
            case sql_type
            when 'inet', 'cidr' then super(PostgreSQLColumn.cidr_to_string(value), column)
            else super
            end
          when Float
            if value.infinite? && column.type == :datetime
              "'#{value.to_s.downcase}'"
            elsif value.infinite? || value.nan?
              "'#{value.to_s}'"
            else
              super
            end
          when Numeric
            if sql_type == 'money' || [:string, :text].include?(column.type)
              # Not truly string input, so doesn't require (or allow) escape string syntax.
              "'#{value}'"
            else
              super
            end
          when String
            case sql_type
            when 'bytea' then "'#{escape_bytea(value)}'"
            when 'xml'   then "xml '#{quote_string(value)}'"
            when /^bit/
              case value
              when /^[01]*$/      then "B'#{value}'" # Bit-string notation
              when /^[0-9A-F]*$/i then "X'#{value}'" # Hexadecimal notation
              end
            else
              super
            end
          else
            super
          end
        end

        def type_cast(value, column, array_member = false)
          return super(value, column) unless column

          case value
          when Range
            return super(value, column) unless /range$/ =~ column.sql_type
            PostgreSQLColumn.range_to_string(value)
          when NilClass
            if column.array && array_member
              'NULL'
            elsif column.array
              value
            else
              super(value, column)
            end
          when Array
            case column.sql_type
            when 'point' then PostgreSQLColumn.point_to_string(value)
            when 'json' then PostgreSQLColumn.json_to_string(value)
            else
              return super(value, column) unless column.array
              PostgreSQLColumn.array_to_string(value, column, self)
            end
          when String
            return super(value, column) unless 'bytea' == column.sql_type
            { :value => value, :format => 1 }
          when Hash
            case column.sql_type
            when 'hstore' then PostgreSQLColumn.hstore_to_string(value)
            when 'json' then PostgreSQLColumn.json_to_string(value)
            else super(value, column)
            end
          when IPAddr
            return super(value, column) unless ['inet','cidr'].include? column.sql_type
            PostgreSQLColumn.cidr_to_string(value)
          else
            super(value, column)
          end
        end
      end
    end
  end
end
