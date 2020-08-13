defmodule AwsParameterStoreConfigProvider.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_parameter_store_config_provider,
      version: "1.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: "release config provider to read secrets from AWS Systems Manager Parameter Store",
      package: package(),
      deps: deps(),
      name: "AwsParameterStoreConfigProvider",
      docs: [
        main: "AwsParameterStoreConfigProvider",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1.3"},
      {:ex_aws_ssm, "~> 2.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", ".formatter.exs"],
      maintainers: ["Luke Ledet"],
      licenses: ["MIT"],
      links: %{
        Documentation: "https://hexdocs.pm/aws_parameter_store_config_provider",
        GitHub: "https://github.com/revelrylabs/aws_parameter_store_config_provider"
      }
    ]
  end
end
