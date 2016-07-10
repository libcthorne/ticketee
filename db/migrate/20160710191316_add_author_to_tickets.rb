class AddAuthorToTickets < ActiveRecord::Migration
  def change
    #add_reference :tickets, :author, index: true, foreign_key: true
    # foreign_key: true wouldn't cause any problems for SQLite as it isn't supported
    # but other DBMS would try and use a non-existent "authors" table
    # Changed to ->
    add_reference :tickets, :author, index: true
    add_foreign_key :tickets, :users, column: :author_id
  end
end
