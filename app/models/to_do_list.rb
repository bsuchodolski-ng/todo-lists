class ToDoList < ApplicationRecord
  belongs_to :user
  # validates :title, presence: true
  validates :user, presence: true
  has_many :to_do_list_items, dependent: :destroy
end
