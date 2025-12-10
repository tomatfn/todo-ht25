require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'





# Routen /
get '/' do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    @results = db.execute("SELECT * FROM todos WHERE done=?", 0)
    @done = db.execute("SELECT * FROM todos WHERE done=?", 1)
    slim(:index)
end

get '/todos/:id/edit' do
  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true
  @result = db.execute("SELECT * FROM todos WHERE id=?", params[:id].to_i).first
  slim(:edit)
end

post('/todo') do 
    name = params[:name] 
    description = params[:description]
    done = 0
    db = SQLite3::Database.new("db/todos.db")
    db.execute("INSERT INTO todos (name, description, done) VALUES (?,?,?)", [name, description, done])
    redirect('/')
  end

  post('/todo/:id/update') do
    id = params[:id].to_i
    name = params[:name]
    description = params[:description]
    done = params[:done] == "on" ? 1 : 0

    db = SQLite3::Database.new("db/todos.db")
    db.execute("UPDATE todos SET name=?, description=?, done=? WHERE id=?", [name, description, done, id])
  
    redirect('/')
  end

  post('/todo/:id/update_done') do
    db = SQLite3::Database.new("db/todos.db")
    id = params[:id].to_i
    done = db.execute("SELECT done FROM todos WHERE id=?", params[:id].to_i).first.first
    if done == 0
      done = 1
    else
      done = 0
    end
    db.execute("UPDATE todos SET done=? WHERE id=?", [done, id])
    redirect('/')
  end
  

  post('/todo/:id/delete') do
    db = SQLite3::Database.new("db/todos.db")
    ta_bort = params[:id].to_i
    db.execute("DELETE FROM todos WHERE id=?", ta_bort)
    redirect('/')
  end



