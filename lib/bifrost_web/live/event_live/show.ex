defmodule BifrostWeb.EventLive.Show do
  use BifrostWeb, :live_view

  alias Bifrost.Events
  alias Bifrost.Events.QRCode

  on_mount {BifrostWeb.Live.UserAuth, :ensure_authenticated}

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    user = socket.assigns.current_scope.user

    case Events.get_event_by_slug(slug) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Event not found")
         |> push_navigate(to: ~p"/events")}

      event ->
        # Verify this event belongs to the current user
        if event.user_id == user.id do
          # Generate QR code
          base_url = get_base_url(socket)
          {:ok, qr_svg} = QRCode.generate_svg(event, base_url)

          {:ok,
           socket
           |> assign(:event, event)
           |> assign(:qr_svg, qr_svg)
           |> assign(:base_url, base_url)
           |> assign(:page_title, event.name)}
        else
          {:ok,
           socket
           |> put_flash(:error, "You don't have permission to view this event")
           |> push_navigate(to: ~p"/events")}
        end
    end
  end

  defp get_base_url(socket) do
    uri = socket.host_uri

    "#{uri.scheme}://#{uri.host}#{if uri.port != 80 && uri.port != 443, do: ":#{uri.port}", else: ""}"
  end
end
