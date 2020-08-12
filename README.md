# AwsParameterStoreConfigProvider

[![Hex.pm Version](http://img.shields.io/hexpm/v/aws_parameter_store_config_provider.svg?style=flat)](https://hex.pm/packages/aws_parameter_store_config_provider)

AwsParameterStoreConfigProvider is an Elixir [release config provider](https://hexdocs.pm/elixir/Config.Provider.html) for loading secrets from [AWS Systems Manager Parameter Store](https://aws.amazon.com/systems-manager/features/#Parameter_Store) into app env at runtime.

Built with [ExAws.SSM](https://github.com/hellogustav/ex_aws_ssm)

## Installation

The package can be installed by adding `aws_parameter_store_config_provider` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aws_parameter_store_config_provider, "~> 1.0.0"}
  ]
end
```

Configure [your release](https://hexdocs.pm/mix/Mix.Tasks.Release.html) and add AwsParameterStoreConfigProvider as a config provider

```
def project
  [
    releases: [
      app: [
        config_providers: [{AwsParameterStoreConfigProvider, nil}]
      ]
    ]
  ]
```

## Configuration

Read the [ExAws](https://github.com/ex-aws/ex_aws), and configure ex_aws with your credentials

## Usage

The provider will resolve secrets stored matching two patterns: strings or tuples. Tuples can contain a function to transform the secret

```elixir
config :my_app, MyApp.Endpoint,
  secret_key_base: "secret:/my_app/secret_key_base",

config :my_app, MyApp.Repo,
  hostname: "secret:/my_app/database/hostname",
  username: "secret:/my_app/database/username",
  password: "secret:/my_app/database/password",
  database: "secret:/my_app/database/database",
  port: {"secret:/my_app/database/port", fn port -> String.to_integer(port) end}
```

A string address is expected to include `secret:/path`

The transformation function is useful for changing a secret's datatype because everything comes out as a string

## Credits

This code was mostly copied straight from the [VaultConfigProvider](https://github.com/sevenmind/vault_config_provider) and made to support AWS Parameter Store
