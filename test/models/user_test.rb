require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = build(:user)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'valid email should be accepted' do
    valid_addresses = %w[
      foo@baz.com
      foo.bar@baz.com
      foo@bar.baz.com
      foo+bar@baz.com
      123456789@baz.com
      foo@baz-quz.com
      _@baz.com
      ________@baz.com
      foo@baz.name
      foo@baz.co.uk
      foo-bar@baz.com
      baz.com@baz.com
      foo.bar+qux@baz.com
      foo.bar-qux@baz.com
      f@baz.com
      _foo@baz.com
      foo@bar--baz.com
    ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'invalid emails shoul not be accepted' do
    invalid_addresses = %w[
      foo
      #@%^%#$@#$@#.com
      @baz.com
      Jane Doe <foo@baz.com>
      qux.baz.com
      foo@bar@baz.com
      あいうえお@baz.com
      foo@baz
      foo@123.456.789.12345
      a"b(c)d,e:f;g<h>I[j\k]l@baz.com
      'foo bar@baz.com'
      foo@baz.com-
      foo@baz,qux.com
      foo\@bar@baz.com
      foo.bar
      @
      @@
      .@
    ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email should be unique' do
    @user.save
    @another_user = build(:user)
    assert_not @another_user.valid?
  end

  test 'password should be present' do
    @user.password = ' '
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = 'a' * 7
    assert_not @user.valid?
  end
end
