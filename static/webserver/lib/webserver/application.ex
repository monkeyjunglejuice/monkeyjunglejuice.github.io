defmodule Webserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Webserver.Worker.start_link(arg)
      # {Webserver.Worker, arg}
      {Plug.Cowboy,
       scheme: :http,
       plug: Webserver,
       options: [ip: {127, 0, 0, 1}, port: 50081]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webserver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
