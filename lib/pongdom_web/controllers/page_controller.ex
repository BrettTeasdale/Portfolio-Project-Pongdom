defmodule PongdomWeb.PageController do
  use PongdomWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
