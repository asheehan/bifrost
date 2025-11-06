defmodule BifrostWeb.EventLive.New do
  use BifrostWeb, :live_view

  alias Bifrost.Events
  alias Bifrost.Events.Event

  on_mount {BifrostWeb.Live.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    changeset = Events.change_event(%Event{})

    {:ok,
     socket
     |> assign(:page_title, "New Event")
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      %Event{}
      |> Events.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    user = socket.assigns.current_scope.user
    event_params = Map.put(event_params, "user_id", user.id)

    case Events.create_event(event_params) do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_navigate(to: ~p"/events")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
