defmodule Bifrost.EventsTest do
  use Bifrost.DataCase

  alias Bifrost.Events
  alias Bifrost.Events.Event

  describe "events" do
    @valid_attrs %{name: "Summer Wedding 2024", user_id: 1}
    @update_attrs %{name: "Summer Wedding 2024 - Updated"}
    @invalid_attrs %{name: nil, user_id: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "list_events_for_user/1 returns events for a specific user" do
      event1 = event_fixture(%{user_id: 1})
      event2 = event_fixture(%{user_id: 2})

      user_1_events = Events.list_events_for_user(1)
      assert length(user_1_events) == 1
      assert hd(user_1_events).id == event1.id
      refute Enum.any?(user_1_events, fn e -> e.id == event2.id end)
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id).id == event.id
    end

    test "get_event_by_slug!/1 returns the event with given slug" do
      event = event_fixture()
      assert Events.get_event_by_slug!(event.slug).id == event.id
    end

    test "create_event/1 with valid data creates an event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.name == "Summer Wedding 2024"
      assert event.user_id == 1
      assert event.slug != nil
      # Verify slug is a valid UUID
      assert {:ok, _} = Ecto.UUID.cast(event.slug)
    end

    test "create_event/1 automatically generates a UUID slug" do
      assert {:ok, %Event{} = event1} = Events.create_event(@valid_attrs)
      assert {:ok, %Event{} = event2} = Events.create_event(@valid_attrs)

      # Both should have UUIDs
      assert {:ok, _} = Ecto.UUID.cast(event1.slug)
      assert {:ok, _} = Ecto.UUID.cast(event2.slug)

      # Slugs should be unique
      assert event1.slug != event2.slug
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event name" do
      event = event_fixture()
      original_slug = event.slug

      assert {:ok, %Event{} = updated_event} = Events.update_event(event, @update_attrs)
      assert updated_event.name == "Summer Wedding 2024 - Updated"
      # Slug should not change
      assert updated_event.slug == original_slug
    end

    test "update_event/2 does not allow changing the slug" do
      event = event_fixture()
      original_slug = event.slug
      new_slug = Ecto.UUID.generate()

      assert {:ok, %Event{} = updated_event} =
               Events.update_event(event, %{slug: new_slug})

      # Slug should remain unchanged
      assert updated_event.slug == original_slug
      assert updated_event.slug != new_slug
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event.id == Events.get_event!(event.id).id
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns an event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  defp event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Events.create_event()

    event
  end
end
