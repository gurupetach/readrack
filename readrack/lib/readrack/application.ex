defmodule Readrack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReadrackWeb.Telemetry,
      Readrack.Repo,
      {DNSCluster, query: Application.get_env(:readrack, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Readrack.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Readrack.Finch},
      # Start a worker by calling: Readrack.Worker.start_link(arg)
      # {Readrack.Worker, arg},
      # Start to serve requests, typically the last entry
      ReadrackWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Readrack.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReadrackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
