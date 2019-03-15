# encoding: utf-8
# Author: root@localhost.network

gcp_project_id = attribute('gcp_project_id')

control 'bq-public-dataset' do
  impact 1.0
  title 'Check that no BQ datasets are public.'
  google_bigquery_datasets(project: gcp_project_id).dataset_references.each do |dataset_name|
    google_bigquery_dataset(project: gcp_project_id, name: dataset_name).access.each do |dataset_access|
      describe dataset_access do
        its('special_group') { should_not cmp 'allUsers' }
        its('special_group') { should_not cmp 'allAuthenticatedUsers' }
      end
    end
  end
end
