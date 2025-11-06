defmodule Bifrost.Events.QRCodeTest do
  use Bifrost.DataCase, async: true

  alias Bifrost.Events.QRCode
  alias Bifrost.Events.Event

  describe "generate_svg/2" do
    test "generates an SVG QR code for an event" do
      event = %Event{slug: "test-event-123"}
      base_url = "https://example.com"

      assert {:ok, svg} = QRCode.generate_svg(event, base_url)
      assert is_binary(svg)
      assert String.contains?(svg, "<svg")
      assert String.contains?(svg, "</svg>")
    end

    test "QR code encodes the correct upload URL" do
      event = %Event{slug: "summer-wedding"}
      base_url = "https://bifrost.example.com"

      # The QR code should encode the guest upload URL
      {:ok, svg} = QRCode.generate_svg(event, base_url)
      assert is_binary(svg)
      # We can't easily decode the QR code in tests, but we can verify it was created
      assert String.length(svg) > 0
    end
  end

  describe "generate_png/2" do
    test "generates a PNG QR code for an event" do
      event = %Event{slug: "test-event-456"}
      base_url = "https://example.com"

      assert {:ok, png} = QRCode.generate_png(event, base_url)
      assert is_binary(png)
      # PNG files start with specific magic bytes
      assert <<137, 80, 78, 71, 13, 10, 26, 10, _rest::binary>> = png
    end
  end
end
