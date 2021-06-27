defmodule BatchstripWeb.PageController do
  use BatchstripWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
