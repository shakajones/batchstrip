defmodule Batchstrip.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BatchstripWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Batchstrip.PubSub},
      # Start the Endpoint (http/https)
      BatchstripWeb.Endpoint
      # Start a worker by calling: Batchstrip.Worker.start_link(arg)
      # {Batchstrip.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Batchstrip.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BatchstripWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
