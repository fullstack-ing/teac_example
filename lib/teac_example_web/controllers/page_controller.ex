defmodule TeacExampleWeb.PageController do
  use TeacExampleWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def twitch(conn, params) do
    dbg([conn, params])
    text(conn, :ok)
  end
end
