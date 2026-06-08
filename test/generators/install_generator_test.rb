require "test_helper"
require "rails/generators"
require "generators/athena_admin/install/install_generator"

class InstallGeneratorTest < ActiveSupport::TestCase
  test "generator class is defined" do
    assert defined?(AthenaAdmin::Generators::InstallGenerator)
  end

  test "source theme css exists in the gem" do
    assert AthenaAdmin::Engine.root.join("app/assets/stylesheets/athena_admin.css").exist?
  end

  test "five woff2 fonts are shipped in the gem" do
    dir = AthenaAdmin::Engine.root.join("app/assets/fonts/athena_admin")
    woff2 = dir.children.count { |c| c.to_s.end_with?(".woff2") }
    assert_operator woff2, :>=, 5
  end
end
