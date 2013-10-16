require 'spec_helper'
require 'securerandom'

describe BinarySolo::CLI::Init do
  Given(:random_dir) { "/tmp/spec_binary_solo/#{SecureRandom.hex(3)}" }
  Given(:cli_init)   { BinarySolo::CLI::Init.new([random_dir]) }

  after(:all) do
    FileUtils.rm_rf "/tmp/spec_binary_solo"
  end

  context 'directory doesnt exist' do

    Then { cli_init.valid? == true }

    context 'when running' do
      When(:result) { cli_init.run }

      Then { result == true }
      Then do 
        File.exist?(random_dir) && %w(ssl config .git).map { |f| File.exist?("#{random_dir}/#{f}") }.all?
      end
    end
  end

  context "directory already exists" do
    before do
      FileUtils.mkdir_p random_dir
    end

    Then { cli_init.valid? == nil }
  end
end