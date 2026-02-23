defmodule PatrioticDemocracy.Inventory.Store do
  use Ecto.Schema

  schema "stores" do
    field(:name, :string)
    field(:location, :string)
    field(:is_active, :boolean, default: true)
    has_many(:inventories, PatrioticDemocracy.Inventory.Inventory)
    has_many(:orders, PatrioticDemocracy.Sales.Order)

    timestamps()
  end
end
