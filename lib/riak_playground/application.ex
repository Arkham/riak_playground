defmodule RiakPlayground.Application do
  use Application
  require Logger

  def start(_type, _args) do
    case RiakPlayground.Supervisor.start_link do
      {:ok, pid} ->
        :ok = :riak_core.register(vnode_module: RiakPlayground.VNode)
        :ok = :riak_core_node_watcher.service_up(RiakPlayground.Service, self())
        {:ok, pid}
      {:error, reason} ->
        Logger.error("Unable to start RiakPlayground Supervisor because #{inspect(reason)}")
    end
  end
end
