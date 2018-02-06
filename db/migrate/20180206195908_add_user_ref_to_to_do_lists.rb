class AddUserRefToToDoLists < ActiveRecord::Migration[5.1]
  def change
    add_reference :to_do_lists, :user, foreign_key: true
  end
end
