defmodule PatrioticDemocracy.Inventory.Supplier do
  use Ecto.Schema

  schema "suppliers" do
    field(:name, :string)
    field(:contact_email, :string)
    field(:contact_phone, :string)
    field(:is_active, :boolean, default: true)
    has_many(:products, PatrioticDemocracy.Catalog.Product)

    timestamps()
  end
end
