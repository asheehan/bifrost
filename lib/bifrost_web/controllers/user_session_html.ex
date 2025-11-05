defmodule BifrostWeb.UserSessionHTML do
  use BifrostWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:bifrost, Bifrost.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
