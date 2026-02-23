defmodule PatrioticDemocracy.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field(:name, :string)
    field(:description, :string)
    field(:is_active, :boolean, default: true)
    has_many(:products, PatrioticDemocracy.Catalog.Product)

    timestamps()
  end
end
