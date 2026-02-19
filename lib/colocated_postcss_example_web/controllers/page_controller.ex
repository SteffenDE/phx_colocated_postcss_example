defmodule ColocatedPostcssExampleWeb.PageController do
  use ColocatedPostcssExampleWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
