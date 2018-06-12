require "sqlite3"

require_relative 'foo.rb'

class FooRepository  
  def initialize(db)
    @db = db
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
    raise "Impossible! Should only be one foo with id #{id}. Check your constraints." if results.size > 1
    return nil if results.size < 1
    FooRepository.from_row results[0]
  end

  def size
    @db.get_first_value('SELECT COUNT(1) FROM foos')
  end

  def delete_by_id(id)
    @db.execute('DELETE FROM foos WHERE id = ?', id)
  end

  def find_all
    results = []
    @db.execute('SELECT id, name FROM foos').each {|row|
      results << FooRepository.from_row(row)
    }
    results
  end

  def create(foo)
    @db.execute('INSERT INTO foos (id, name) VALUES (?, ?)', foo.id, foo.name)
  end

  def update(foo)
    @db.execute('UPDATE foos SET name = ? WHERE id = ?', foo.name, foo.id)
  end

  private

  def self.from_row(row) 
    Foo.new row[0], row[1]
  end

end
