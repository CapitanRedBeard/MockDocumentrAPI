defmodule ExampleProject.PageController do
  use ExampleProject.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
