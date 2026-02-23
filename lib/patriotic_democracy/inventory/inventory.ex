defmodule PatrioticDemocracy.Inventory.Inventory do
  use Ecto.Schema

  schema "inventory" do
    field(:quantity, :integer)
    field(:reserved_quantity, :integer)
    field(:reorder_level, :integer)
    field(:last_restocked_at, :naive_datetime)

    belongs_to(:product, PatrioticDemocracy.Catalog.Product)
    belongs_to(:store, PatrioticDemocracy.Inventory.Store)

    timestamps()
  end
end
