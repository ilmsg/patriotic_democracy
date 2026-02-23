defmodule PatrioticDemocracy.Sales.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field(:quantity, :integer)
    field(:unit_price, :decimal)
    field(:total_price, :decimal)

    belongs_to(:order, PatrioticDemocracy.Sales.Order)
    belongs_to(:product, PatrioticDemocracy.Catalog.Product)

    timestamps()
  end

  @doc """
  Changeset สำหรับจัดการรายการสินค้าแต่ละชิ้นในใบสั่งซื้อ
  """
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity, :unit_price, :total_price, :order_id, :product_id])
    |> validate_required([:quantity, :unit_price, :order_id, :product_id])

    # 1. ตรวจสอบจำนวนและราคาห้ามติดลบ หรือเป็น 0 (ต้องซื้ออย่างน้อย 1 ชิ้น)
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:unit_price, greater_than_or_equal_to: 0)

    # 2. คำนวณราคารวมอัตโนมัติ (หากไม่ได้ส่งมา) และตรวจสอบความถูกต้อง
    |> calculate_total_price()

    # 3. ตรวจสอบความสัมพันธ์ของ Foreign Key
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:product_id)
  end

  # Helper สำหรับคำนวณ total_price: quantity * unit_price
  defp calculate_total_price(changeset) do
    qty = get_field(changeset, :quantity)
    price = get_field(changeset, :unit_price)

    if qty && price do
      total = Decimal.mult(Decimal.new(qty), price)
      put_change(changeset, :total_price, total)
    else
      changeset
    end
  end
end
