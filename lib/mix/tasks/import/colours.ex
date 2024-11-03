defmodule Mix.Tasks.Import.Colours do
  @moduledoc """
  Import colours from stdin in csv format.
  """

  use Mix.Task

  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Colour

  def run(_) do
    Mix.Task.run("app.start")

    IO.stream()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1, "\t", trim: true))
    |> Stream.map(fn [name, hex_code] -> %{name: name, hex_code: hex_code} end)
    |> Stream.map(&Colour.changeset(%Colour{}, &1))
    |> Stream.map(&Repo.insert(&1))
    |> Stream.filter(&(elem(&1, 0) == :error))
    |> Stream.map(&IO.inspect(&1))
    |> Stream.run()
  end
end
