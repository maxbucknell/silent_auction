defmodule SilentAuction.Api.GraphQL.Dataloader do
  def new() do
    source = Dataloader.Ecto.new(SilentAuction.DB.Repo, query: &query/2)

    Dataloader.new()
    |> Dataloader.add_source(:db, source)
  end

  def query(queryable, _params) do
    queryable
  end
end
