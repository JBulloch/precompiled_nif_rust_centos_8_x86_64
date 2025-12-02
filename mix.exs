defmodule Explorer.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/JBulloch/precompiled_nif_rust_centos_8_x86_64"

  def project do
    [
      app: :explorer,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: "Pre-compiled NIF for Explorer/Polars on CentOS 8 x86_64",
      package: package(),
      deps: deps()
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "native",
        "checksum-*.exs",
        "mix.exs"
      ],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler_precompiled, "~> 0.7"},
      {:rustler, ">= 0.0.0", optional: true}
    ]
  end
end