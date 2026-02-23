defmodule PatrioticDemocracy.Inventory.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field(:name, :string)
    field(:location, :string)
    field(:is_active, :boolean, default: true)
    has_many(:inventories, PatrioticDemocracy.Inventory.Inventory)
    has_many(:orders, PatrioticDemocracy.Sales.Order)

    timestamps()
  end

  @doc """
  Changeset สำหรับจัดการข้อมูลสาขา/คลังสินค้า
  """
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :location, :is_active])
    # บังคับระบุชื่อและที่ตั้งสาขา
    |> validate_required([:name, :location])
    # ชื่อสาขาต้องไม่สั้นหรือยาวเกินไป
    |> validate_length(:name, min: 3, max: 100)
    # ที่ตั้งต้องมีความชัดเจนพอสมควร
    |> validate_length(:location, min: 5, max: 255)
    # ป้องกันการตั้งชื่อสาขาซ้ำกัน
    |> unique_constraint(:name)
  end
end
