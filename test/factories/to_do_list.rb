require 'ffaker'

FactoryBot.define do
  factory :to_do_list do
    title FFaker::Movie.title + 'list'
    user
  end
end
