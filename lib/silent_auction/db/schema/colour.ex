defmodule SilentAuction.DB.Schema.Colour do
  import Bitwise

  use Ecto.Schema

  alias SilentAuction.DB.Schema

  schema "colours" do
    field(:name, :string)
    field(:value, :integer)

    field(:r, :integer, read_after_writes: true)
    field(:g, :integer, read_after_writes: true)
    field(:b, :integer, read_after_writes: true)

    field(:hex_code, :string, read_after_writes: true)

    belongs_to(:account, Schema.Account)
  end

  def changeset(colour, params \\ %{}) do
    value =
      case params do
        %{hex_code: hex_code} -> hex_code_to_value(hex_code)
        %{r: r, g: g, b: b} -> components_to_value(r, g, b)
        %{value: value} -> value
        %{} -> colour.value
      end

    params = Map.put(params, :value, value)

    colour
    |> Ecto.Changeset.cast(params, [:name, :value])
    |> Ecto.Changeset.cast_assoc(:account, with: &Schema.Account.changeset/2)
    |> Ecto.Changeset.validate_required([:name, :value])
    |> Ecto.Changeset.validate_number(:value, greater_than_or_equal_to: 0, less_than: 0x100000000)
  end

  defp hex_code_to_value(hex_code) do
    hex_code
    |> String.trim("#")
    |> String.to_integer(16)
    |> (&<<</2).(8)
  end

  defp components_to_value(r, g, b) do
    (r <<< 24) + (g <<< 16) + (b <<< 8)
  end
end
