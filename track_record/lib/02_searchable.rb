require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    search_line = []
    values = []
    params.each do |col, value|
      search_line << "#{col} = ?"
      values << value
    end
    search_line = search_line.join(' AND ')
    results = DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{search_line}
    SQL
    parse_all(results)
  end
end

class SQLObject
  class << self
    include Searchable
  end
end
