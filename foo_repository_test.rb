require 'test/unit'
require_relative 'foo_repository.rb'
require_relative 'foo.rb'

class FooRepositoryTest < Test::Unit::TestCase

  def setup
    db = SQLite3::Database.new "test.db"  
    @foos = FooRepository.new(db)
    @foos.drop_table
    @foos.create_table
  end

  def teardown
    @foos.drop_table
  end

  def test_returns
    assert_nil @foos.find_by_id('0'*30), 'Returns nil when foo not found.'
  end

  def test_create_and_find
    foo1 = Foo.create('I am a foo')
    @foos.create(foo1)
    foo2 = @foos.find_by_id(foo1.id)
    puts foo2
    assert_equal foo1, foo2
  end

  def test_updates_persist
    foo1 = Foo.create('I am a foo')
    @foos.create(foo1)
    foo1.name = 'I changed my name'
    assert_equal foo1.name, 'I changed my name'
    @foos.update(foo1)
    foo2 = @foos.find_by_id(foo1.id)
    assert_equal foo2.name, 'I changed my name'
    assert_equal foo1, foo2
  end

  def test_find_all
    foo1 = Foo.create('First Foo')
    foo2 = Foo.create('Second Foo')
    @foos.create(foo1)
    @foos.create(foo2)
    results = @foos.find_all
    assert_equal results.size, 2
    results.each do |foo|
      assert (foo.is_a? Foo)
    end
    puts [1, 2, 3].to_json
    puts results.to_json
  end

  def test_delete
    assert_equal 0, @foos.size
    foo = Foo.create('test')
    @foos.create foo
    assert_equal 1, @foos.size
    @foos.delete_by_id foo.id
    assert_equal 0, @foos.size
  end


end
