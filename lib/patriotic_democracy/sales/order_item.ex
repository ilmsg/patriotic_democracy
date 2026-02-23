defmodule PatrioticDemocracy.Sales.OrderItem do
  use Ecto.Schema

  schema "order_items" do
    field(:quantity, :integer)
    field(:unit_price, :decimal)
    field(:total_price, :decimal)

    belongs_to(:order, PatrioticDemocracy.Sales.Order)
    belongs_to(:product, PatrioticDemocracy.Catalog.Product)

    timestamps()
  end
end
