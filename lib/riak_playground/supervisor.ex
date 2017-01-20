defmodule RiakPlayground.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: :riak_playground_sup])
  end

  def init([]) do
    children = [
      worker(:riak_core_vnode_master, [RiakPlayground.VNode], id: RiakPlayground.VNode_master_worker)
    ]

    supervise(children,
              strategy: :one_for_one,
              max_restarts: 5,
              max_seconds: 10)
  end
end
