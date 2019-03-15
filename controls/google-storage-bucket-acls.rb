# encoding: utf-8
# Author: root@localhost.network

gcp_project_id = attribute('gcp_project_id')

control 'gcs-public-bucket' do
  impact 1.0
  title 'Check that the storage bucket is not public.'
  google_storage_buckets(project: gcp_project_id).bucket_names.each do |bucket_name|
    google_storage_bucket_iam_bindings(bucket: bucket_name).iam_binding_roles.each do |iam_binding_role|
      describe google_storage_bucket_iam_binding(bucket: bucket_name,  role: iam_binding_role) do
        its('members') { should_not include 'allUsers' }
        its('members') { should_not include 'allAuthenticatedUsers' }
      end
    end
  end
end

control 'gcs-exist' do
  impact 0.1
  title 'Check that the test public storage bucket exists.'
  describe google_storage_buckets(project: gcp_project_id) do
    its('bucket_names'){ should include "ublicpay" }
  end
end
