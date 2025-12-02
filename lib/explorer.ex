defmodule Explorer.Native do
  @moduledoc """
  Pre-compiled NIF module for Explorer using rustler_precompiled.

  This module loads pre-compiled native binaries for Explorer/Polars,
  specifically built for CentOS 8 x86_64.
  """

  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :explorer,
    crate: "explorer",
    base_url: "https://github.com/JBulloch/precompiled_nif_rust_centos_8_x86_64/releases/download/v#{version}",
    force_build: System.get_env("EXPLORER_BUILD") in ["1", "true"],
    version: version

  @doc """
  Adds two integers.
  """
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Returns a greeting from the NIF.
  """
  def hello(), do: :erlang.nif_error(:nif_not_loaded)
end