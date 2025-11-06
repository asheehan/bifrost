defmodule BifrostWeb.EventQRCodeController do
  use BifrostWeb, :controller

  alias Bifrost.Events
  alias Bifrost.Events.QRCode

  def download(conn, %{"slug" => slug}) do
    user = conn.assigns.current_scope.user

    case Events.get_event_by_slug(slug) do
      nil ->
        conn
        |> put_flash(:error, "Event not found")
        |> redirect(to: ~p"/events")

      event ->
        # Verify this event belongs to the current user
        if event.user_id == user.id do
          # Generate QR code PNG
          base_url = get_base_url(conn)
          {:ok, png_data} = QRCode.generate_png(event, base_url)

          conn
          |> put_resp_content_type("image/png")
          |> put_resp_header(
            "content-disposition",
            "attachment; filename=\"#{slug}-qr-code.png\""
          )
          |> send_resp(200, png_data)
        else
          conn
          |> put_flash(:error, "You don't have permission to download this QR code")
          |> redirect(to: ~p"/events")
        end
    end
  end

  defp get_base_url(conn) do
    scheme = if conn.scheme == :https, do: "https", else: "http"
    host = conn.host
    port = conn.port

    port_string = if port in [80, 443], do: "", else: ":#{port}"
    "#{scheme}://#{host}#{port_string}"
  end
end
