require "sqlite3"

require_relative 'foo.rb'

class FooRepository  
  include Enumerable

  def initialize(db)
    @db = db
    db.results_as_hash = true
  end

  def create_table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS foos (
        id   CHAR(20),
        name TEXT
      );
    SQL
  end

  def drop_table
    @db.execute("DROP TABLE IF EXISTS foos")
  end 

  def find_by_id(id)
    results = @db.execute('SELECT id, name FROM foos WHERE id = ?', id)
    case results.size
    when 0
      nil
    when 1
      FooRepository.from_row results[0]
    else
      raise "Error! Should be at most one 'foo' with id '#{id}'. Check your constraints." 
    end
  end

  def [] id
    find_by_id id
  end

  def size
    @db.get_first_value('SELECT COUNT(1) FROM foos')
  end

  def delete_by_id(id)
    @db.execute('DELETE FROM foos WHERE id = ?', id)
  end

  def find_all
    @db.execute('SELECT id, name FROM foos').map { |row| FooRepository.from_row row }
  end

  def each
    find_all
  end

  def create(foo)
    @db.execute('INSERT INTO foos (id, name) VALUES (?, ?)', foo.id, foo.name)
  end

  def update(foo)
    @db.execute('UPDATE foos SET name = ? WHERE id = ?', foo.name, foo.id)
  end

  def << foo 
    if self[foo.id].nil? then
      create foo
    else
      update foo
    end
    self
  end

  private

  def self.from_row(row) 
    Foo.new row['id'], row['name']
  end

end
