require 'ffaker'

FactoryBot.define do
  factory :to_do_list_item do
    content { FFaker::Movie.unique.title }
    to_do_list
  end
end
