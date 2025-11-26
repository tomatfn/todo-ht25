require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'





# Routen /
get '/' do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    @results = db.execute("SELECT * FROM todos")
    slim(:index)
end

post('/todo') do # app.rb
    name = params[:name] 
    description = params[:description]

    db = SQLite3::Database.new("db/todos.db")
    db.execute("INSERT INTO todos (name, description) VALUES (?,?)", [name, description])
    redirect('/')
  end

  post('/todo/:id/update') do
    db.execute("UPDATE todos SET name=?, age=? WHERE id=?", [params[:name], params[:description]])
    redirect('/')
  end

  post('/todo/:id/delete') do
    db = SQLite3::Database.new("db/todos.db")
    ta_bort = params[:id].to_i
    db.execute("DELETE FROM todos WHERE id=?", ta_bort)
    redirect('/')
  end



