defmodule AwsParameterStoreConfigProvider do
  @moduledoc """
  AwsParameterStoreConfigProvider is a [release config provider](https://hexdocs.pm/elixir/Config.Provider.html).

  Any value set as `"secret:/foo/bar"` or `{"secret:/foo/bar", fn secret -> String.to_integer(secret) end}`
  will be resolved from ParameterStore.

  This provider uses [ex_aws](https://github.com/ex-aws/ex_aws) and should have keys configured
  """

  @behaviour Config.Provider

  def init(_), do: nil

  def load(config, _) do
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:ex_aws)

    Config.Reader.merge(config, resolve_secrets(config))
  end

  def resolve_secrets(config) do
    Enum.map(config, &eval_secret(&1, config))
  end

  defp eval_secret("secret:" <> path, _config) do
    fetch_parameter(path)
  end

  defp eval_secret({"secret:" <> path, fun}, _config) when is_function(fun) do
    secret = fetch_parameter(path)

    fun.(secret)
  end

  defp eval_secret({key, val}, config) do
    {key, eval_secret(val, config)}
  end

  defp eval_secret(val, config) when is_list(val), do: Enum.map(val, &eval_secret(&1, config))

  defp eval_secret(other, _config), do: other

  defp fetch_parameter(path) do
    path
    |> ExAws.SSM.get_parameter(with_decryption: true)
    |> ExAws.request!()
    |> case do
      %{"Parameter" => %{"Value" => secret}} ->
        secret

      error ->
        raise ArgumentError, "secret at #{path} returned #{inspect(error)}"
    end
  end
end
