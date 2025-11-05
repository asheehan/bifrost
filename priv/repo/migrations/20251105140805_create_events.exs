defmodule Bifrost.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :slug, :string
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:events, [:slug])
  end
end
