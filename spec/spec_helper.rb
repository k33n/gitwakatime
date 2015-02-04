# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
ENV['thor_env'] = 'test'
ENV['waka_log'] = 'false'

require 'gitwakatime'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.before(:all) do
    @wdir = set_file_paths
    GitWakaTime.config.setup_local_db
    GitWakaTime::Commit.new.columns
    GitWakaTime::CommitedFile.new.columns
  end

  config.before(:each) do
    GitWakaTime::Commit.truncate
    GitWakaTime::CommitedFile.truncate
    
    expect(GitWakaTime.config).to receive('user_name').and_return("Russell Osborne").at_least(:once)
  end

  config.after(:all) do
    FileUtils.rm_r(File.dirname(@wdir))
  end
end
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'webmock/rspec'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

def set_file_paths
  @test_dir = File.join(File.dirname(__FILE__))
  @wdir_dot = File.expand_path(File.join(@test_dir, 'dummy'))
  @wdir = create_temp_repo(@wdir_dot)
end

def create_temp_repo(clone_path)
  filename = 'git_test' + Time.now.to_i.to_s + rand(300).to_s.rjust(3, '0')
  @tmp_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp', filename))
  FileUtils.mkdir_p(@tmp_path)
  FileUtils.cp_r(clone_path, @tmp_path)
  tmp_path = File.join(@tmp_path, 'dummy')
  Dir.chdir(tmp_path) do
    FileUtils.mv('dot_git', '.git')
  end
  tmp_path
end
