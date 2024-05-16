require 'sqlite3'

def db
    if @db == nil
        @db = SQLite3::Database.new('./db/db.sqlite')
        @db.results_as_hash = true
    end
    return @db
end

def drop_tables
    db.execute('DROP TABLE IF EXISTS ingredients')
end

def create_tables

    db.execute('CREATE TABLE "users" (
        "username"	TEXT NOT NULL,
        "password"	TEXT NOT NULL,
        "id"	INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
    );')


    db.execute('CREATE TABLE "ingredients" (
        "id"	INTEGER NOT NULL,
        "name"	TEXT NOT NULL,
        "price"	INTEGER NOT NULL,
        "type"	TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
    );)')

    db.execute('CREATE TABLE "order" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
    );')

    db.execute('CREATE TABLE "order_ingredients" (
        "id"	INTEGER NOT NULL,
        "order_id"	INTEGER NOT NULL,
        "ingredient_id"	INTEGER NOT NULL,
        PRIMARY KEY("id")
    );')

end

def seed_tables

    ingredients = [
        {name:'Nötfärs', price:'20', type:'Kott'},
        {name:'Högrevsfärs', price:'30', type:'Kott'},
        {name:'Haloumiburgare', price:'25', type:'Kott'},
        {name:'Vegofärs', price:'20', type:'Kott'},
        {name:'Sallad', price:'5', type:'Gronsaker'},
        {name:'Tomat', price:'5', type:'Gronsaker'},
        {name:'Gurka', price:'5', type:'Gronsaker'},
        {name:'Lök', price:'5', type:'Gronsaker'},
        {name:'Saltgurka', price:'5', type:'Gronsaker'},
        {name:'Karamelliserad lök', price:'7', type:'Gronsaker'},
        {name:'Ketchup', price:'5', type:'Sas'},
        {name:'Hamburgedressing', price:'5', type:'Sas'},
        {name:'Majonäs', price:'5', type:'Sas'},
        {name:'Barbequesås', price:'5', type:'Sas'},
        {name:'Vitt bröd', price:'10', type:'Brod'},
        {name:'Fullkornsbröd', price:'10', type:'Brod'},
        {name:'Sesambröd', price:'12', type:'Brod'},
        {name:'Glutenfritt bröd', price:'12', type:'Brod'},
        {name:'Cheddarost', price:'5', type:'Tillbehor'},
        {name:'Bacon', price:'15', type:'Tillbehor'}
    ]

    ingredients.each do |ingredient|
        db.execute('INSERT INTO ingredients (name, price, type) VALUES (?,?,?)', ingredient[:name], ingredient[:price], ingredient[:type])
    end

end

drop_tables
create_tables
seed_tables
