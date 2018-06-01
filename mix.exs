defmodule AwsExRayPlug.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_ex_ray_plug,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      applications: [:logger, :plug, :aws_ex_ray]
    ]
  end

  defp deps do
    [
      # FIXME use hex.pm
      {:aws_ex_ray, github: "lyokato/aws_ex_ray"},
      {:struct_assert, "~> 0.5.2", only: :test},
      {:mox, "~> 0.3.2", only: :test},
      {:plug, "~> 1.5"}
    ]
  end
end
