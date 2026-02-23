defmodule PatrioticDemocracy.Repo.Migrations.CreateStoreTables do
  use Ecto.Migration

  def change do
    # 1. Categories
    create table(:categories) do
      add :name, :string, null: false
      add :description, :text
      add :is_active, :boolean, default: true, null: false
      timestamps()
    end

    # 2. Suppliers
    create table(:suppliers) do
      add :name, :string, null: false
      add :contact_email, :string
      add :contact_phone, :string
      add :is_active, :boolean, default: true, null: false
      timestamps()
    end

    # 3. Stores
    create table(:stores) do
      add :name, :string, null: false
      add :location, :string
      add :is_active, :boolean, default: true, null: false
      timestamps()
    end

    # 4. Products
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :sku, :string, null: false
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :is_active, :boolean, default: true, null: false
      add :deleted_at, :naive_datetime
      add :category_id, references(:categories, on_delete: :nilify_all)
      add :supplier_id, references(:suppliers, on_delete: :nilify_all)
      timestamps()
    end
    create unique_index(:products, [:sku])

    # 5. Inventory
    create table(:inventory) do
      add :quantity, :integer, default: 0, null: false
      add :reserved_quantity, :integer, default: 0
      add :reorder_level, :integer, default: 10
      add :last_restocked_at, :naive_datetime
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :store_id, references(:stores, on_delete: :delete_all), null: false
      timestamps()
    end

    # 6. Orders
    create table(:orders) do
      add :order_number, :string, null: false
      add :customer_email, :string
      add :status, :string, default: "pending", null: false
      add :total_amount, :decimal, precision: 12, scale: 2
      add :order_date, :naive_datetime
      add :store_id, references(:stores, on_delete: :restrict)
      timestamps()
    end
    create unique_index(:orders, [:order_number])

    # 7. Order Items
    create table(:order_items) do
      add :quantity, :integer, null: false
      add :unit_price, :decimal, precision: 10, scale: 2, null: false
      add :total_price, :decimal, precision: 12, scale: 2, null: false
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :product_id, references(:products, on_delete: :restrict), null: false
      timestamps()
    end

    # 8. Price History
    create table(:price_history) do
      add :old_price, :decimal, precision: 10, scale: 2
      add :new_price, :decimal, precision: 10, scale: 2
      add :change_reason, :string
      add :effective_date, :naive_datetime
      add :product_id, references(:products, on_delete: :delete_all)
      add :supplier_id, references(:suppliers, on_delete: :nilify_all)
      timestamps()
    end
  end
end
