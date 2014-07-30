require 'puppet'
require 'puppet/type/mysql_user'
describe Puppet::Type.type(:mysql_user) do

  it 'should require a name' do
    expect {
      Puppet::Type.type(:mysql_user).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'using 12345678901234567@localhost' do
    before :each do
      @user = Puppet::Type.type(:mysql_user).new(:name => '12345678901234567@localhost', :password_hash => 'pass')
    end

    it 'should accept a user name' do
      @user[:name].should == '12345678901234567@localhost'
    end

    it 'should accept a password' do
      @user[:password_hash] = 'foo'
      @user[:password_hash].should == 'foo'
    end
  end

  context 'using foo@LocalHost' do
    before :each do
      @user = Puppet::Type.type(:mysql_user).new(:name => 'foo@LocalHost', :password_hash => 'pass')
    end

    it 'should lowercase the user name' do
      @user[:name].should == 'foo@localhost'
    end

  end
end
