# encoding: utf-8
# Author: root@localhost.network

gcp_project_id = attribute('gcp_project_id')

control 'firewall-internet' do
  impact 0.5
  title 'Check that no firewalls rules exist that allow communication with the entire internet.'
  google_compute_firewalls(project: gcp_project_id).firewall_names.each do |firewall_name|
    describe google_compute_firewall(project: gcp_project_id,  name: firewall_name) do
      it { should_not allow_ip_ranges ["0.0.0.0/0"] }
      it { should_not allow_port_protocol("22", "tcp") }
    end
  end
end

control 'no-egress-prod' do
  impact 0.7
  title 'Do not allow egress rules in the project.'
  describe google_compute_firewalls(project: gcp_project_id).where(firewall_direction: 'EGRESS') do
    it { should_not exist }
  end
end

control 'no-internet-ingress' do
  impact 0.7
  title 'Do not allow the entire internet into the project.'
  describe google_compute_firewalls(project: gcp_project_id).where(firewall_direction: 'INGRESS') do
    it { should_not allow_ip_ranges ["0.0.0.0/0"] }
  end
end
