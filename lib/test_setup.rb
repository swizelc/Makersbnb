require 'pg'
#u
def clear_test_db
    connection = PG.connect(dbname: 'makersbnb_test')
    connection.exec("TRUNCATE users;")
end