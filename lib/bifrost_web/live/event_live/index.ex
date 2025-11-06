defmodule BifrostWeb.EventLive.Index do
  use BifrostWeb, :live_view

  alias Bifrost.Events

  on_mount {BifrostWeb.Live.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    # Get current user from socket.assigns.current_scope.user
    user = socket.assigns.current_scope.user
    events = Events.list_events_for_user(user.id)

    {:ok, assign(socket, events: events, page_title: "My Events")}
  end
end
