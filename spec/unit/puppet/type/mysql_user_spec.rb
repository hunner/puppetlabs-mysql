require 'puppet'
require 'puppet/type/mysql_user'

provider_class = Puppet::Type.type(:mysql_user).provider(:mariadb)

describe Puppet::Type.type(:mysql_user) do
  let(:resource) do
    user = described_class.new(:name => "#{username}@LocalHost", :password_hash => 'pass')
    # validation happens before a provider is set. How can we trigger validation?
    user.provider = provider_class.new(user)
    described_class.new(user)
  end
  before :each do
    Puppet::Util.stubs(:which).with('mysql').returns('/usr/bin/mysql')
  end

  describe '#name' do
    context 'mariadb provider' do
      before :each do
        provider_class.stubs(:version_check).with("10.0.0-MariaDB").returns(true)
      end

      context 'using long user names' do
        let(:username) { 'eighteencharacters' }
        it 'should accept a user name' do
          resource[:name].should == 'eighteencharacters@localhost'
        end
      end
    end

    context 'mysql provider' do
      before :each do
        provider_class.stubs(:version_check).with("10.0.0-MariaDB").returns(false)
      end

      context 'using long user names' do
        let(:username) { 'eighteencharacters' }
        it 'should reject a long user name' do
          expect { resource[:name] }.to raise_error Puppet::Error
        end
      end

      context 'using short user names' do
        let(:username) { 'sixteencharacter' }
        it 'should accept a short user name lowercased' do
          resource[:name].should == 'sixteencharacter@localhost'
        end
      end
    end
  end
end
