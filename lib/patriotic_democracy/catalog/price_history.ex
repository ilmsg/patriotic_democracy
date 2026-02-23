defmodule PatrioticDemocracy.Catalog.PriceHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "price_history" do
    field(:old_price, :decimal)
    field(:new_price, :decimal)
    field(:change_reason, :string)
    field(:effective_date, :naive_datetime)

    belongs_to(:product, PatrioticDemocracy.Catalog.Product)
    belongs_to(:supplier, PatrioticDemocracy.Inventory.Supplier)

    timestamps()
  end

  @doc """
  Changeset สำหรับบันทึกประวัติราคา (Audit Log)
  """
  def changeset(price_history, attrs) do
    price_history
    |> cast(attrs, [
      :old_price,
      :new_price,
      :change_reason,
      :effective_date,
      :product_id,
      :supplier_id
    ])
    # บังคับต้องระบุเหตุผลและราคา
    |> validate_required([:old_price, :new_price, :change_reason, :product_id])
    |> validate_number(:old_price, greater_than_or_equal_to: 0)
    |> validate_number(:new_price, greater_than_or_equal_to: 0)
    # ป้องกันการใส่เหตุผลสั้นเกินไป เช่น "-" หรือ "ok"
    |> validate_length(:change_reason, min: 5, max: 255)
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:supplier_id)
    |> put_default_effective_date()
  end

  # Helper เพื่อตั้งค่าวันที่มีผลหากไม่ได้ระบุมา
  defp put_default_effective_date(changeset) do
    case get_field(changeset, :effective_date) do
      nil ->
        put_change(
          changeset,
          :effective_date,
          NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        )

      _ ->
        changeset
    end
  end
end
