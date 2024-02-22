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
        {name:'Nötfärs', price:'20', type:'Kött'},
        {name:'Högrevsfärs', price:'30', type:'Kött'},
        {name:'Haloumiburgare', price:'25', type:'Kött'},
        {name:'Vegofärs', price:'20', type:'Kött'},
        {name:'Sallad', price:'5', type:'Grönsaker'},
        {name:'Tomat', price:'5', type:'Grönsaker'},
        {name:'Gurka', price:'5', type:'Grönsaker'},
        {name:'Lök', price:'5', type:'Grönsaker'},
        {name:'Saltgurka', price:'5', type:'Grönsaker'},
        {name:'Karamelliserad lök', price:'7', type:'Grönsaker'},
        {name:'Ketchup', price:'5', type:'Sås'},
        {name:'Hamburgedressing', price:'5', type:'Sås'},
        {name:'Majonäs', price:'5', type:'Sås'},
        {name:'Barbequesås', price:'5', type:'Sås'},
        {name:'Vitt bröd', price:'10', type:'Bröd'},
        {name:'Fullkornsbröd', price:'10', type:'Bröd'},
        {name:'Sesambröd', price:'12', type:'Bröd'},
        {name:'Glutenfritt bröd', price:'12', type:'Bröd'},
        {name:'Cheddarost', price:'5', type:'Tillbehör'},
        {name:'Bacon', price:'15', type:'Tillbehör'}
    ]

    ingredients.each do |ingredient|
        db.execute('INSERT INTO ingredients (name, price, type) VALUES (?,?,?)', ingredient[:name], ingredient[:price], ingredient[:type])
    end

end

drop_tables
create_tables
seed_tables