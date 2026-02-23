defmodule PatrioticDemocracy.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:name, :string)
    field(:description, :string)
    field(:sku, :string)
    field(:price, :decimal)
    field(:is_active, :boolean, default: true)
    field(:deleted_at, :naive_datetime)

    belongs_to(:category, PatrioticDemocracy.Catalog.Category)
    belongs_to(:supplier, PatrioticDemocracy.Inventory.Supplier)
    has_many(:inventory_items, PatrioticDemocracy.Inventory.Inventory)

    timestamps()
  end
end
