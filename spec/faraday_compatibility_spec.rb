module Fastlane
  class Action
  end unless const_defined?(:Action, false)
end

describe "Faraday compatibility" do
  it "declares faraday-multipart as a runtime dependency" do
    gemspec_path = File.expand_path("../fastlane-plugin-pgyer.gemspec", __dir__)
    specification = Gem::Specification.load(gemspec_path)

    dependency_names = specification.runtime_dependencies.map(&:name)

    expect(dependency_names).to include("faraday-multipart")
  end

  it "builds a multipart client with the active Faraday version" do
    action_path = File.expand_path("../lib/fastlane/plugin/pgyer/actions/pgyer_action.rb", __dir__)

    expect { require(action_path) }.not_to raise_error

    connection = Fastlane::Actions::PgyerAction.send(
      :create_faraday_client,
      { request: { timeout: 1, open_timeout: 1 } },
    )
    handler_names = connection.builder.handlers.map { |handler| handler.klass.name }

    expect(handler_names).to include("Faraday::Multipart::Middleware")
  end
end
