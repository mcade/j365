defmodule J365.PageController do
  use J365.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
