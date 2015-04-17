require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'
require 'haml'
require 'redcarpet'

require_relative 'models/todo'

class Mosscow < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  helpers Sinatra::JSON

  set :static, true
  set :public_folder, 'public'
  set :views, File.dirname(__FILE__) + '/views'
  set :raise_errors, true
  set :show_exceptions, false # uncomment here when you do NOT want to see a backtrace
  set :database_file, 'config/database.yml'

  configure :development do
    register Sinatra::Reloader
  end

  before do
    ActiveRecord::Base.establish_connection(ENV['RACK_ENV'].to_sym)
    content_type 'text/html'
  end

  helpers do
    def json_halt(status, object)
      halt status, { 'Content-Type' => 'application/json' }, JSON.dump(object)
    end

    def parse_json(string)
      JSON.parse(string)
    rescue => e
      p e.backtrace unless ENV['RACK_ENV'] == 'test'
      json_halt 400, message: 'set valid JSON for request raw body.'
    end
  end

  get '/problems' do
    haml :problems
  end

  get '/404' do
    halt 404, File.read('public/404.txt')
  end

  get '/500' do
    halt 500, haml(:internal_server_error)
  end

  get '/400' do
    halt 400, haml(:bad_request)
  end

  get '/error' do
    fail
  end

  get '/' do
    content_type 'text/plain'
    'Hello, Mosscow!'
  end

  get '/api/todos' do
    todos = Todo.all

    content_type :json
    JSON.dump(todos.as_json)
  end

  delete '/api/todos/:id' do
    todo = Todo.where(id: params['id']).first
    todo.destroy
    response.status = 204
    nil
  end

  put '/api/todos/:id' do
    params = parse_json(request.body.read)
    todo = Todo.where(id: params['id']).first
    todo.is_done = params['is_done']
    todo.task_title = params['task_title']
    if todo.valid?
      todo.save!
      json todo.as_json
    else
      json_halt 400, message: todo.errors.messages
    end
  end

  post '/api/todos' do
    params = parse_json(request.body.read)
    todo = Todo.new(task_title: params['task_title'],
                    is_done: params['is_done'],
                    order: params['order'])
    if todo.valid?
      todo.save!
      response.status = 201
      json todo.as_json
    else
      json_halt 400, message: todo.errors.messages
    end
  end

  after do
    ActiveRecord::Base.connection.close
  end
end
