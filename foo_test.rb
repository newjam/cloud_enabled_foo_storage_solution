require 'test/unit'
require_relative 'foo.rb'

class FooTest < Test::Unit::TestCase

  def test_to_json
    f = Foo.new '0'*30, 'test'
    #j = f.to_json

    #a = [f].to_json


    #h = JSON.parse(j)
    #assert_equal f.id, h['id']
    #assert_equal f.name, h['name']
  end

end
