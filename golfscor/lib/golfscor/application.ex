defmodule Golfscor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GolfscorWeb.Telemetry,
      Golfscor.Repo,
      {DNSCluster, query: Application.get_env(:golfscor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Golfscor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Golfscor.Finch},
      # Start a worker by calling: Golfscor.Worker.start_link(arg)
      # {Golfscor.Worker, arg},
      # Start to serve requests, typically the last entry
      GolfscorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Golfscor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GolfscorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
