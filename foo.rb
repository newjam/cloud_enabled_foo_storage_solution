require 'base62'
require 'json'

class Foo
  attr_reader :id, :name
  attr_writer :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.create(name)
    Foo.new(create_id, name)
  end

  def self.create_id
    rand(0 .. 62**30).base62_encode
  end

  def ==(other)
    id == other.id && name == other.name
  end

  def to_s
    return "foo id='#{id}' name='#{name}'"
  end

  def to_hash
    return { 
      :id => id,
      :name => name
    }
  end

end
