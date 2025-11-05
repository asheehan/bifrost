defmodule Bifrost.Repo.Migrations.AddUserFkeyToEvents do
  use Ecto.Migration

  def change do
    # Add foreign key constraint from events.user_id to users.id
    alter table(:events) do
      modify :user_id, references(:users, on_delete: :delete_all), from: {:integer, null: true}
    end

    create index(:events, [:user_id])
  end
end
