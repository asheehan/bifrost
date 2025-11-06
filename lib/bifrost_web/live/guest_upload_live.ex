defmodule BifrostWeb.GuestUploadLive do
  use BifrostWeb, :live_view

  alias Bifrost.Events

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    case Events.get_event_by_slug(slug) do
      nil ->
        {:ok,
         socket
         |> assign(:event, nil)
         |> assign(:page_title, "Event Not Found")}

      event ->
        {:ok,
         socket
         |> assign(:event, event)
         |> assign(:page_title, event.name)
         |> assign(:upload_ready, false)}
    end
  end

  @impl true
  def handle_event("prepare_upload", _params, socket) do
    {:noreply, assign(socket, :upload_ready, true)}
  end
end
