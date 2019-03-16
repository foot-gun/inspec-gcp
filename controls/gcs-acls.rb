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

control 'gcs-allUsers-object' do
  impact 1.0
  title 'Check that the storage object does not have an ACL for allUsers.'
  google_storage_buckets(project: gcp_project_id).bucket_names.each do |bucket_name|
    google_storage_bucket_objects(bucket: bucket_name).object_names.each do |object_name|
      describe google_storage_object_acl(bucket: bucket_name, object: object_name, entity: 'allUsers') do
        it { should_not exist }
      end
    end
  end
end

control 'gcs-allAuthenticatedUsers-object' do
  impact 1.0
  title 'Check that the storage object does not have an ACL for allAuthenticatedUsers.'
  google_storage_buckets(project: gcp_project_id).bucket_names.each do |bucket_name|
    google_storage_bucket_objects(bucket: bucket_name).object_names.each do |object_name|
      describe google_storage_object_acl(bucket: bucket_name, object: object_name, entity: 'allAuthenticatedUsers') do
        it { should_not exist }
      end
    end
  end
end

control 'gcs-allUsers-default' do
  impact 1.0
  title 'Check that there is no default storage object ACL for allUsers.'
  google_storage_buckets(project: gcp_project_id).bucket_names.each do |bucket_name|
    google_storage_bucket_objects(bucket: bucket_name).object_names.each do |object_name|
      describe google_storage_default_object_acl(bucket: bucket_name,  entity: 'allUsers') do
        it { should_not exist }
      end
    end
  end
end

control 'gcs-allAuthenticatedUsers-default' do
  impact 1.0
  title 'Check that there is no default storage object ACL for allAuthenticatedUsers.'
  google_storage_buckets(project: gcp_project_id).bucket_names.each do |bucket_name|
    google_storage_bucket_objects(bucket: bucket_name).object_names.each do |object_name|
      describe google_storage_default_object_acl(bucket: bucket_name,  entity: 'allAuthenticatedUsers') do
        it { should_not exist }
      end
    end
  end
end
