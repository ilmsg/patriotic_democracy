defmodule PatrioticDemocracy.Inventory.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory" do
    field(:quantity, :integer, default: 0)
    field(:reserved_quantity, :integer, default: 0)
    field(:reorder_level, :integer, default: 10)
    field(:last_restocked_at, :naive_datetime)

    belongs_to(:product, PatrioticDemocracy.Catalog.Product)
    belongs_to(:store, PatrioticDemocracy.Inventory.Store)

    timestamps()
  end

  @doc """
  Changeset สำหรับจัดการสต็อกสินค้าในแต่ละสาขา
  """
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [
      :quantity,
      :reserved_quantity,
      :reorder_level,
      :last_restocked_at,
      :product_id,
      :store_id
    ])
    |> validate_required([:quantity, :product_id, :store_id])

    # 1. ป้องกันจำนวนสินค้าติดลบ
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_number(:reserved_quantity, greater_than_or_equal_to: 0)
    |> validate_number(:reorder_level, greater_than_or_equal_to: 0)

    # 2. ตรวจสอบเงื่อนไขทางธุรกิจ: จำนวนจองต้องไม่มากกว่าจำนวนที่มี
    |> validate_reserved_not_exceeding_quantity()

    # 3. ตรวจสอบความสัมพันธ์
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:store_id)

    # 4. ป้องกันการสร้างสต็อกซ้ำซ้อนในสาขาเดียวกัน (ต้องมี unique_index ใน migration)
    |> unique_constraint([:product_id, :store_id], name: :inventory_product_id_store_id_index)
  end

  # Custom Validation: เช็คว่า reserved_quantity <= quantity
  defp validate_reserved_not_exceeding_quantity(changeset) do
    qty = get_field(changeset, :quantity) || 0
    reserved = get_field(changeset, :reserved_quantity) || 0

    if reserved > qty do
      add_error(changeset, :reserved_quantity, "จำนวนที่จองไว้ห้ามมากกว่าจำนวนสินค้าที่มีในคลัง")
    else
      changeset
    end
  end
end
