require File.expand_path('../test_helper', __FILE__)

class ActiveRecordTest < Test::Unit::TestCase

  def setup
    ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
    create_users_table
    @user = User.create :first_name => 'John', :last_name => "Doe"
  end

  def test_should_raise_exeptions
    assert_raise NoMethodError do 
      @user.async_notexistent
    end
    assert_raise NoMethodError do 
      @user.notexistent
    end
    assert_raise NoMethodError do
      User.notexistsmethod
    end
    assert_raise NoMethodError do
      User.sync_notexistsmethod
    end
  end

  def test_should_call_methods
    assert_equal @user.name, "John Doe"
    assert_equal @user.sync_name, "John Doe"
    assert_equal @user.async_name, "John Doe"

    assert_equal User.full_name, "John Doe"
    assert_equal User.async_full_name, "John Doe"
    assert_equal User.sync_full_name, "John Doe"
  end

  def test_should_call_methods_with_arguments
    assert_equal User.hello("World"), "Hello World"
    assert_equal User.async_hello("World"), "Hello World"
    assert_equal User.sync_hello("World"), "Hello World"
  end
end
