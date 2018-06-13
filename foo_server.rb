require 'sinatra'
require 'json'
require 'sqlite3'
require_relative 'foo'
require_relative 'foo_repository'

db = SQLite3::Database.open('foo.db')

foos = FooRepository.new(db)
foos.create_table

get '/foos', :provides => :json do
  response_array = foos.map do |foo|
    {
      "url"  => "http://#{request.host_with_port}/foos/#{foo.id}",
      "name" => foo.name
    }
  end

  [200, JSON.generate(response_array)]
end

get '/foos/:id', :provides => :json do
  id = params[:id]
  foo = foos[id]
  return 404 if foo.nil?
  response_object = {
    "url"  => "http://#{request.host_with_port}/foos/#{foo.id}",
    "name" => foo.name
  }
  return [200, JSON.generate(response_object)] 
end

put '/foos/:id', :provides => :json do
  id = params[:id]
  json = JSON.parse request.body.read
  name = json['name']

  foo = Foo.new id, name
  foos << foo

  response_object = {
    "url"  => "http://#{request.host_with_port}/foos/#{foo.id}",
    "name" => foo.name
  }

  return [200, JSON.generate(response_object)]
end

delete '/foos/:id' do
  id = params[:id]
  foos.delete_by_id id
  return 204
end

post '/foos', :provides => :json do
  json = JSON.parse request.body.read
  name = json['name']

  foo = Foo.create(name)
  foos << foo

  response_object = {
    "url"  => "http://#{request.host_with_port}/foos/#{foo.id}",
    "name" => foo.name
  }

  [201, JSON.generate(response_object)]
end

