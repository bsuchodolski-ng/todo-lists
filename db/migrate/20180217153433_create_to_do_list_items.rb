class CreateToDoListItems < ActiveRecord::Migration[5.1]
  def change
    create_table :to_do_list_items do |t|
      t.belongs_to :to_do_list
      t.string :content
      t.boolean :done, default: false
      t.timestamps
    end
  end
end
