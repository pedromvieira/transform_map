defmodule TransformMap.MixProject do
  use Mix.Project

  def project do
    [
      app: :transform_map,
      version: "1.0.3",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Transform Map",
      source_url: "https://github.com/pedromvieira/transform_map"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Transform Elixir Deeply Nested Maps into flat maps or 2 dimensional array. Export any map to CSV, XLSX or JSON.
    """
  end

  defp package do
    [
      name: :transform_map,
      files: ["lib", "mix.exs", "LICENSE", "README.md"],
      maintainers: ["Pedro Vieira - pedro@vieira.net"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pedromvieira/transform_map"}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.18.0", only: :dev},
      {:parallel_stream, ">= 1.0.0"},
      {:csvlixir, ">= 2.0.0"},
      {:elixlsx, ">= 0.4.0"},
      {:exjsx, ">= 4.0.0"},
      {:decimal, ">= 1.5.0"},
    ]
  end
end
