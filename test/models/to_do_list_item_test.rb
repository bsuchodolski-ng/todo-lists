require 'test_helper'

class ToDoListItemTest < ActiveSupport::TestCase

  def setup
    @to_do_list_item = build(:to_do_list_item)
  end

  test 'should be valid' do
    assert @to_do_list_item.valid?
  end

  test 'content should be present' do
    @to_do_list_item.content = ''
    assert_not @to_do_list_item.valid?
  end

  test 'to do list should be present' do
    @to_do_list_item.to_do_list = nil
    assert_not @to_do_list_item.valid?
  end
end
