defmodule Bifrost.Events.QRCode do
  @moduledoc """
  Generates QR codes for event upload URLs.
  """

  alias Bifrost.Events.Event

  @doc """
  Generates a QR code for the event's guest upload URL.

  Returns the QR code as an SVG string that can be embedded in HTML.

  ## Examples

      iex> event = %Event{slug: "abc123"}
      iex> generate_svg(event, "https://example.com")
      {:ok, "<svg..."}
  """
  def generate_svg(%Event{slug: slug}, base_url) do
    upload_url = "#{base_url}/events/#{slug}/upload"

    qr_code = EQRCode.encode(upload_url)
    svg = EQRCode.svg(qr_code)
    {:ok, svg}
  end

  @doc """
  Generates a QR code as PNG binary data for downloading.

  Returns the QR code as PNG binary that can be sent as a download.

  ## Examples

      iex> event = %Event{slug: "abc123"}
      iex> generate_png(event, "https://example.com")
      {:ok, <<binary_data>>}
  """
  def generate_png(%Event{slug: slug}, base_url) do
    upload_url = "#{base_url}/events/#{slug}/upload"

    qr_code = EQRCode.encode(upload_url)
    png = EQRCode.png(qr_code)
    {:ok, png}
  end
end
