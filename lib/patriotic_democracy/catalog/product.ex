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

  @doc """
  Changeset สำหรับการจัดการข้อมูลสินค้า
  """
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :sku, :price, :is_active, :category_id, :supplier_id])
    # ฟิลด์ที่จำเป็นต้องมี
    |> validate_required([:name, :sku, :price, :category_id])
    # ราคาห้ามติดลบ
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_format(:sku, ~r/^[A-Z0-9-]+$/,
      message: "SKU ต้องเป็นตัวพิมพ์ใหญ่ ตัวเลข หรือขีด (-) เท่านั้น"
    )
    |> validate_length(:sku, min: 3, max: 50)
    # ป้องกัน SKU ซ้ำ (ต้องคู่กับ unique_index ใน migration)
    |> unique_constraint(:sku)
    # ตรวจสอบว่า Category ID มีอยู่จริงในระบบ
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:supplier_id)
  end
end
