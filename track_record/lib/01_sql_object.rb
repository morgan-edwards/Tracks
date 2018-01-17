require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    return @columns if @columns
    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
        0
    SQL
    @columns = columns.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |name|

      define_method("#{name}") do
        attributes[name]
      end

      define_method("#{name}=") do |data|
        attributes[name] = data
      end

    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.reduce([]) do |acc, hash|
      acc << self.new(hash)
    end
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL
    return nil if result.empty?
    self.new(result.first)
  end

  def initialize(params = {})
    cols = self.class.columns
    cols += cols.map(&:to_s)
    params.each do |attribute, data|
      method = "#{attribute}="
      if cols.include?(attribute)
        self.send(method, data)
      else
        raise "unknown attribute '#{attribute}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map {|col| self.send(col)}
  end

  def insert
    cols = self.class.columns.drop(1)
    col_names = cols.map(&:to_s).join(', ')
    qs = (['?'] * cols.length).join(', ')
    values = attribute_values.drop(1)
    DBConnection.execute(<<-SQL, *values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{qs})
      SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    setters = self.class.columns.drop(1).map(&:to_s).map do |col|
      col += " = ?"
    end.join(', ')
    vals = attribute_values.drop(1)
    DBConnection.execute(<<-SQL, *vals, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{setters}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end

  def save
    if self.class.find(self.id)
      self.update
    else
      self.insert
    end
  end
end
