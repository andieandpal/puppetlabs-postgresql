require 'spec_helper_system'

describe 'postgresql::contrib:' do
  after :all do
    # Cleanup after tests have ran, remove both contrib and server as contrib
    # pulls in the server based packages.
    pp = <<-EOS
      class { 'postgresql::server':
        ensure => absent,
      }
      class { 'postgresql::contrib':
        package_ensure => purged,
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pp = <<-EOS
      class { 'postgresql::server': }
      class { 'postgresql::contrib': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end
end
