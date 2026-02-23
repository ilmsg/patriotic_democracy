defmodule PatrioticDemocracy.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field(:name, :string)
    field(:description, :string)
    field(:is_active, :boolean, default: true)
    has_many(:products, PatrioticDemocracy.Catalog.Product)

    timestamps()
  end

  @doc """
  Changeset สำหรับสร้างและอัปเดตข้อมูลหมวดหมู่
  """
  def changeset(category, attrs) do
    category
    # ระบุฟิลด์ที่อนุญาตให้แก้ไข
    |> cast(attrs, [:name, :description, :is_active])
    # ชื่อหมวดหมู่ห้ามเป็นค่าว่าง
    |> validate_required([:name])
    # กำหนดความยาวของชื่อ
    |> validate_length(:name, min: 2, max: 100)
    # ป้องกันการตั้งชื่อหมวดหมู่ซ้ำกันใน Database
    |> unique_constraint(:name)
  end
end
