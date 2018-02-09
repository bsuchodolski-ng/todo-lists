class ToDoList < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :user, presence: true
end
