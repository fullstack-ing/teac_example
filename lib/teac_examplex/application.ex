defmodule TeacExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TeacExampleWeb.Telemetry,
      TeacExample.Repo,
      {DNSCluster, query: Application.get_env(:teac_example, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TeacExample.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TeacExample.Finch},
      {DynamicSupervisor, name: TeacExample.TwitchWssClientSupervisor, strategy: :one_for_one},
      # Start a worker by calling: TeacExample.Worker.start_link(arg)
      # {TeacExample.Worker, arg},
      # Start to serve requests, typically the last entry
      TeacExampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TeacExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TeacExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
