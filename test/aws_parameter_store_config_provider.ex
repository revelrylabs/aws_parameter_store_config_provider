defmodule AwsParameterStoreConfigProviderTest do
  use ExUnit.Case

  import Mock

  setup_with_mocks([
    {ExAws, [], [request!: fn _ -> %{"Parameter" => %{"Value" => "ok"}} end]}
  ]) do
    :ok
  end

  describe "resolve secrets" do
    test "single string path" do
      assert [{:app, [some_key: "ok"]} | _] =
               AwsParameterStoreConfigProvider.resolve_secrets(
                 app: [some_key: "secret:secret/services/my_app"]
               )
    end

    test "path with transform" do
      assert [{:app, [some_key: "OK"]} | _] =
               AwsParameterStoreConfigProvider.resolve_secrets(
                 app: [
                   some_key: {"secret:/services/my_app", &String.upcase/1}
                 ]
               )
    end

    test "string paths in array" do
      assert [{:app, [some_key: ["ok", "ok"]]} | _] =
               AwsParameterStoreConfigProvider.resolve_secrets(
                 app: [
                   some_key: [
                     "secret:secret/services/my_app",
                     "secret:secret/services/my_app"
                   ]
                 ]
               )
    end

    test "deeply nested keyword path" do
      assert [{:app, [some_key: [at: [a: [very: [deep: [path: "ok"]]]]]]} | _] =
               AwsParameterStoreConfigProvider.resolve_secrets(
                 app: [
                   some_key: [
                     at: [
                       a: [
                         very: [
                           deep: [
                             path: "secret:/services/my_app"
                           ]
                         ]
                       ]
                     ]
                   ]
                 ]
               )
    end
  end
end
