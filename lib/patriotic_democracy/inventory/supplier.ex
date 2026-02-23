defmodule PatrioticDemocracy.Inventory.Supplier do
  use Ecto.Schema
  import Ecto.Changeset

  schema "suppliers" do
    field(:name, :string)
    field(:contact_email, :string)
    field(:contact_phone, :string)
    field(:is_active, :boolean, default: true)
    has_many(:products, PatrioticDemocracy.Catalog.Product)

    timestamps()
  end

  @doc """
  Changeset สำหรับการจัดการข้อมูลผู้ผลิต/คู่ค้า
  """
  def changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [:name, :contact_email, :contact_phone, :is_active])
    # บังคับระบุชื่อและอีเมล
    |> validate_required([:name, :contact_email])
    |> validate_length(:name, min: 2, max: 150)

    # 1. ตรวจสอบรูปแบบ Email ด้วย Regex
    |> validate_format(:contact_email, ~r/^[^\s]+@[^\s]+$/, message: "รูปแบบอีเมลไม่ถูกต้อง")
    # ป้องกันการใช้อีเมลซ้ำกัน
    |> unique_constraint(:contact_email)

    # 2. ตรวจสอบรูปแบบเบอร์โทรศัพท์ (ตัวเลข 9-15 หลัก)
    |> validate_format(:contact_phone, ~r/^[0-9\-\+\s]+$/, message: "เบอร์โทรศัพท์ต้องเป็นตัวเลขเท่านั้น")
    |> validate_length(:contact_phone, min: 9, max: 15)
    # ป้องกันชื่อผู้ผลิตซ้ำ
    |> unique_constraint(:name)
  end
end
