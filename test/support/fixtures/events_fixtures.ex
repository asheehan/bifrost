defmodule Bifrost.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bifrost.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "7488a646-e31f-11e4-aace-600308960662",
        user_id: 42
      })
      |> Bifrost.Events.create_event()

    event
  end
end
