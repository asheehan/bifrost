defmodule BifrostWeb.EventLive.Index do
  use BifrostWeb, :live_view

  alias Bifrost.Events
  alias Bifrost.Events.Event

  @impl true
  def mount(_params, _session, socket) do
    # Get current user from socket.assigns.current_scope.user
    user = socket.assigns.current_scope.user
    events = Events.list_events_for_user(user.id)

    {:ok, assign(socket, events: events)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Events")
    |> assign(:event, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  @impl true
  def handle_info({BifrostWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, assign(socket, :events, [event | socket.assigns.events])}
  end
end
