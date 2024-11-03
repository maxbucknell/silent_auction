defmodule SilentAuction.DB.Schema.ColourTest do
  use SilentAuction.DBCase

  alias SilentAuction.DB.Repo
  alias SilentAuction.DB.Schema.Colour

  test "can create by hex code" do
    colour = %Colour{}

    changeset =
      Colour.changeset(colour, %{
        name: "Max Red",
        hex_code: "#ab1717"
      })

    assert {:ok, colour} = Repo.insert(changeset)

    IO.inspect(colour)
  end

  test "can load by components or hex code" do
    colour = %Colour{
      name: "Max Red",
      value: 0xAB171700
    }

    changeset = Colour.changeset(colour)

    assert {:ok, colour} = Repo.insert(changeset)

    assert colour.hex_code == "#ab1717"
    assert colour.r == 171
    assert colour.g == 23
    assert colour.b == 23
  end

  test "an empty changeset is invalid" do
    colour = %Colour{}

    changeset = Colour.changeset(colour)

    assert {:error, _} = Repo.insert(changeset)
  end
end
