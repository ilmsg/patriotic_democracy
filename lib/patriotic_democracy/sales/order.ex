defmodule PatrioticDemocracy.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset

  # กำหนดรายการสถานะที่เป็นไปได้
  @statuses ["pending", "completed", "cancelled", "shipped"]

  schema "orders" do
    field(:order_number, :string)
    field(:customer_email, :string)
    field(:status, :string, default: "pending")
    field(:total_amount, :decimal)
    field(:order_date, :naive_datetime)

    belongs_to(:store, PatrioticDemocracy.Inventory.Store)
    has_many(:order_items, PatrioticDemocracy.Sales.OrderItem)

    timestamps()
  end

  @doc """
  Changeset สำหรับการจัดการใบสั่งซื้อ
  """
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :order_number,
      :customer_email,
      :status,
      :total_amount,
      :order_date,
      :store_id
    ])
    |> validate_required([:order_number, :status, :store_id])

    # 1. ตรวจสอบรูปแบบอีเมลลูกค้า (ถ้ามี)
    |> validate_format(:customer_email, ~r/^[^\s]+@[^\s]+$/, message: "รูปแบบอีเมลไม่ถูกต้อง")

    # 2. ควบคุมสถานะให้ตรงตามที่ระบบกำหนดเท่านั้น
    |> validate_inclusion(:status, @statuses,
      message: "สถานะต้องเป็นหนึ่งใน: #{Enum.join(@statuses, ", ")}"
    )

    # 3. ตรวจสอบยอดรวมห้ามติดลบ
    |> validate_number(:total_amount, greater_than_or_equal_to: 0)

    # 4. ป้องกันเลขที่ใบสั่งซื้อซ้ำ
    |> unique_constraint(:order_number)

    # 5. ตรวจสอบว่าสาขา (Store) มีอยู่จริง
    |> foreign_key_constraint(:store_id)

    # 6. ตั้งค่าวันที่สั่งซื้ออัตโนมัติหากไม่ได้ระบุมา
    |> put_default_order_date()
  end

  defp put_default_order_date(changeset) do
    case get_field(changeset, :order_date) do
      nil ->
        put_change(
          changeset,
          :order_date,
          NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        )

      _ ->
        changeset
    end
  end
end
