defmodule TencentCloudCore.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/feng19/tencent_cloud_core"

  def project do
    [
      app: :tencent_cloud_core,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [extra_applications: [:crypto]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: [:docs, :dev], runtime: false}
    ]
  end

  defp docs do
    [
      source_url: @source_url,
      formatters: ["html"]
    ]
  end

  defp package do
    [
      name: "tencent_cloud_core",
      description: "Common functions for TencentCloud",
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["feng19"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
