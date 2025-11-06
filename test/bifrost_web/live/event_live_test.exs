defmodule BifrostWeb.EventLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bifrost.AccountsFixtures

  alias Bifrost.Events

  describe "Index" do
    setup do
      user = user_fixture()
      %{user: user}
    end

    test "lists user's events only", %{conn: conn, user: user} do
      user2 = user_fixture()
      _event1 = create_event(user, %{name: "My Event"})
      _event2 = create_event(user2, %{name: "Other User Event"})

      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/events")

      assert html =~ "My Events"
      assert html =~ "My Event"
      refute html =~ "Other User Event"
    end

    test "requires authentication", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/users/log-in"}}} = live(conn, ~p"/events")
    end

    test "displays new event button", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/events")

      assert index_live |> element("a", "New Event") |> render() =~ "New Event"
    end

    test "saves new event", %{conn: conn, user: user} do
      {:ok, _index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/events")

      # Navigate to new event page
      {:ok, new_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/events/new")

      assert new_live
             |> form("#event-form", event: %{name: ""})
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        new_live
        |> form("#event-form", event: %{name: "Summer Wedding 2024"})
        |> render_submit()
        |> follow_redirect(conn |> log_in_user(user))

      assert html =~ "Event created successfully"
      assert html =~ "Summer Wedding 2024"
    end
  end

  defp create_event(user, attrs) do
    {:ok, event} =
      attrs
      |> Enum.into(%{name: "Some Event", user_id: user.id})
      |> Events.create_event()

    event
  end
end
