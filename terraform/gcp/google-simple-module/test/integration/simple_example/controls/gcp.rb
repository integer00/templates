# frozen_string_literal: true

project_id     = attribute('project_id')
instance_name  = attribute('instance_name')
instance_zone  = attribute('instance_zone')

control "gcp" do
  title "simple gcp instance check"

    describe google_compute_instance(project: project_id, zone: instance_zone, name: instance_name) do
      it { should exist }
      its('name') { should eq instance_name}
    end
end