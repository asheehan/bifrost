defmodule Bifrost.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :slug, :string
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> generate_slug()
    |> unique_constraint(:slug)
  end

  defp generate_slug(%Ecto.Changeset{data: %{slug: nil}} = changeset) do
    # Generate UUID as a string for the slug
    # This allows for custom slugs in the future (paid feature)
    put_change(changeset, :slug, Ecto.UUID.generate())
  end

  defp generate_slug(changeset), do: changeset
end
