defmodule PatrioticDemocracy.Catalog.PriceHistory do
  use Ecto.Schema

  schema "price_history" do
    field(:old_price, :decimal)
    field(:new_price, :decimal)
    field(:change_reason, :string)
    field(:effective_date, :naive_datetime)

    belongs_to(:product, PatrioticDemocracy.Catalog.Product)
    belongs_to(:supplier, PatrioticDemocracy.Inventory.Supplier)

    timestamps()
  end
end
