
title 'Firewall existence check'

gcp_project_id = attribute('gcp_project_id')

google_compute_firewalls(project: gcp_project_id).firewall_names.each do |firewall_name|
  describe google_compute_firewall(project: gcp_project_id,  name: firewall_name) do
    it { should exist }
    its('kind') { should eq "compute#firewall" }
  end
end
