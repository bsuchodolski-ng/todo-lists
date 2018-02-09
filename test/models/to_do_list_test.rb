require 'test_helper'

class ToDoListTest < ActiveSupport::TestCase

  def setup
    @to_do_list = build(:to_do_list)
  end

  test 'should be valid' do
    assert @to_do_list.valid?
  end

  test 'title should be present' do
    @to_do_list.title = ''
    assert_not @to_do_list.valid?
  end

  test 'user should be present' do
    @to_do_list.user = nil
    assert_not @to_do_list.valid?
  end
end
