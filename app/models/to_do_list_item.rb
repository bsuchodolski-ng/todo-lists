class ToDoListItem < ApplicationRecord
  belongs_to :to_do_list
  validates :content, presence: true
  validates :to_do_list, presence: true
end
