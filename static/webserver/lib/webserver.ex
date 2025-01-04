defmodule Webserver do
  @moduledoc """
  Simple webserver for local development of static websites.
  """
  use Plug.Builder

  plug(Plug.Static,
    at: "/",
    from: Path.expand("../../../")
  )
end
