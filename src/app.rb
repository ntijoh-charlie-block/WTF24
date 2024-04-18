require 'debug'
require 'bcrypt'

class App < Sinatra::Base

    enable :sessions


    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end

        return @db
    end


    get '/' do
        user_id = session[:user_id]

        if user_id == nil
            redirect "/login"
        else
            redirect "/build"
        end
    end


    get '/register' do
        erb :'register'
    end

    post '/register' do
        username = params['username']
        cleartext_password = params['password']

        hashed_password = BCrypt::Password.create(cleartext_password)

        db.execute('INSERT INTO users (username, password) VALUES (?, ?)', username, hashed_password)

        redirect '/build'
    end


    get '/login' do
        erb :'login'
    end

    post '/login' do
        username = params['username']
        cleartext_password = params['password']

        user = db.execute('SELECT * FROM users WHERE username = ?', username).first

        if user && BCrypt::Password.new(user['password']) == cleartext_password
            session[:user_id] = user['id']
            redirect '/build'
        else
            redirect "/login"
            "Fel lösenord eller användarnamn"
        end
    end


    get '/build' do
        @ingredients = db.execute('SELECT * FROM ingredients')
        erb :'burgers/build'
    end


    post '/submit' do
        user_id = session[:user_id] #?????????

        order = db.execute("INSERT INTO orders (user_id) VALUES (?) RETURNING id", user_id).first
        order_id = order["id"]


        brod_id = params['selected_Brod']
        db.execute("INSERT INTO order_ingredients (order_id, ingredient_id) VALUES (?, ?)", order_id, brod_id)

        kott_id = params['selected_Kott']
        db.execute("INSERT INTO order_ingredients (order_id, ingredient_id) VALUES (?, ?)", order_id, kott_id)

        gronsaker_ids = params['selected_Gronsaker']
        gronsaker_ids.each do |gronsak_id|
            db.execute("INSERT INTO order_ingredients (order_id, ingredient_id) VALUES (?, ?)", order_id, gronsak_id)
        end

        sas_ids = params['selected_Sas']
        sas_ids.each do |sas_id|
            db.execute("INSERT INTO order_ingredients (order_id, ingredient_id) VALUES (?, ?)", order_id, sas_id)
        end

        tillbehor_ids = params['selected_Tillbehor']
        tillbehor_ids.each do |tillbehor_id|
            db.execute("INSERT INTO order_ingredients (order_id, ingredient_id) VALUES (?, ?)", order_id, tillbehor_id)
        end

        @selected_ingredients = db.execute("SELECT * FROM ingredients WHERE id IN (SELECT ingredient_id FROM order_ingredients WHERE order_id = ?)", order_id)

        total_price = @selected_ingredients.sum { |ingredient| ingredient['price'].to_i }

        erb:'burgers/show', locals: {total_price: total_price}
    end
end
