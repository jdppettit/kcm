defmodule KubectlConfigManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :kubectl_config_manager,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [
        main_module: KubectlConfigManager,
        name: "kcm"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_cli, "~> 0.1.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
