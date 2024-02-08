class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    get '/build' do
        @ingredients = db.execute('SELECT type FROM ingredients')
        erb :'burgers/build'
    end
    


end