defmodule BifrostWeb.GuestUploadLiveTest do
  use BifrostWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bifrost.AccountsFixtures

  alias Bifrost.Events

  describe "Guest Upload Page" do
    setup do
      user = user_fixture()
      {:ok, event} = Events.create_event(%{name: "Wedding Photos", user_id: user.id})
      %{event: event, user: user}
    end

    test "displays event name and upload instructions", %{conn: conn, event: event} do
      {:ok, _view, html} = live(conn, ~p"/events/#{event.slug}/upload")

      assert html =~ "Wedding Photos"
      assert html =~ "Share your photos and videos"
      assert html =~ "Welcome!"
      assert html =~ "Tap the upload button below"
      assert html =~ "Select photos or videos from your device"
    end

    test "does not require authentication", %{conn: conn, event: event} do
      # Should work without being logged in
      {:ok, _view, html} = live(conn, ~p"/events/#{event.slug}/upload")

      assert html =~ event.name
    end

    test "shows error for non-existent event", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/events/invalid-slug-12345/upload")

      assert html =~ "Event Not Found"
      assert html =~ "This event doesn&#39;t exist or may have been deleted"
    end

    test "displays upload button (disabled for now)", %{conn: conn, event: event} do
      {:ok, _view, html} = live(conn, ~p"/events/#{event.slug}/upload")

      assert html =~ "Upload Photos &amp; Videos"
      assert html =~ "Upload functionality coming in Issue #8"
    end

    test "shows privacy message", %{conn: conn, event: event} do
      {:ok, _view, html} = live(conn, ~p"/events/#{event.slug}/upload")

      assert html =~ "No account needed"
      assert html =~ "All uploads are private to this event"
    end

    test "is mobile-friendly with responsive classes", %{conn: conn, event: event} do
      {:ok, _view, html} = live(conn, ~p"/events/#{event.slug}/upload")

      # Check for mobile-first responsive classes
      assert html =~ "min-h-screen"
      assert html =~ "flex flex-col"
      assert html =~ "max-w-md"
    end
  end
end
