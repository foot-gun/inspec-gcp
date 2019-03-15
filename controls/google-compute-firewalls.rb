title 'Firewall existence check'

gcp_project_id = attribute('gcp_project_id')

control 'firewall-existence' do
  impact 0.5
  title 'Check that firewall rules exist in the project.'
  google_compute_firewalls(project: gcp_project_id).firewall_names.each do |firewall_name|
    describe google_compute_firewall(project: gcp_project_id,  name: firewall_name) do
      it { should exist }
      its('kind') { should eq "compute#firewall" }
    end
  end
end

control 'no-egress-prod' do
  impact 0.7
  title 'Do not allow egress rules in prod project.'
  describe google_compute_firewalls(project: gcp_project_id).where(firewall_direction: 'EGRESS') do
    it { should_not exist }
  end
end
