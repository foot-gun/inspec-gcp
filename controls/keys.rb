# encoding: utf-8
# Author: root@localhost.network

gcp_project_id = attribute('gcp_project_id')

control 'no-keys' do
  impact 1.0
  title 'Check that no service accounts have keys.'
  google_service_accounts(project: gcp_project_id).service_account_names.each do |sa_name|
    describe google_service_account_key(name: sa_name) do
      it { should_not exist }
    end
  end
end
