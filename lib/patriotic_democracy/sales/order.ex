defmodule PatrioticDemocracy.Sales.Order do
  use Ecto.Schema

  schema "orders" do
    field(:order_number, :string)
    field(:customer_email, :string)
    field(:status, :string)
    field(:total_amount, :decimal)
    field(:order_date, :naive_datetime)

    belongs_to(:store, PatrioticDemocracy.Inventory.Store)
    has_many(:order_items, PatrioticDemocracy.Sales.OrderItem)

    timestamps()
  end
end
