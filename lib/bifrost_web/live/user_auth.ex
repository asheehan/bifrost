defmodule BifrostWeb.Live.UserAuth do
  @moduledoc """
  Authentication hooks for LiveView.

  Provides `on_mount` hooks that can be used to ensure authentication
  in LiveView modules.
  """

  use BifrostWeb, :verified_routes

  import Phoenix.Component
  import Phoenix.LiveView

  alias Bifrost.Accounts
  alias Bifrost.Accounts.Scope

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_scope(socket, session)

    if socket.assigns.current_scope && socket.assigns.current_scope.user do
      {:cont, socket}
    else
      socket =
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: ~p"/users/log-in")

      {:halt, socket}
    end
  end

  def on_mount(:mount_current_scope, _params, session, socket) do
    {:cont, mount_current_scope(socket, session)}
  end

  defp mount_current_scope(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        case Accounts.get_user_by_session_token(user_token) do
          {user, _token_inserted_at} ->
            assign(socket, :current_scope, Scope.for_user(user))

          nil ->
            assign(socket, :current_scope, Scope.for_user(nil))
        end

      _other ->
        assign(socket, :current_scope, Scope.for_user(nil))
    end
  end
end
