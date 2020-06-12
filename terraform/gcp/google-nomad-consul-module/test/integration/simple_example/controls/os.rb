# frozen_string_literal: true

instance_name  = attribute('instance_name')

control "os" do
  title "simple os check"

    describe bash('hostname') do
      its('stdout') { should match instance_name }
      its('exit_status') { should eq 0 }
    end

     describe file('/etc/hosts') do
       it { should exist }
     end

end