defmodule RiakPlayground.Service do
  def ping(v \\ 1) do
    idx = :riak_core_util.chash_key({"riakplayground", "ping#{v}"})
    pref_list = :riak_core_apl.get_primary_apl(idx, 1, __MODULE__)

    [{index_node, _type}] = pref_list

    :riak_core_vnode_master.sync_command(index_node, {:ping, v}, RiakPlayground.VNode_master)
  end

  def put(k, v) do
    idx = :riak_core_util.chash_key({"riakplayground", k})
    pref_list = :riak_core_apl.get_primary_apl(idx, 1, __MODULE__)

    [{index_node, _type}] = pref_list
    :riak_core_vnode_master.command(index_node, {:put, {k, v}}, RiakPlayground.VNode_master)
  end

  def get(k) do
    idx = :riak_core_util.chash_key({"riakplayground", k})
    pref_list = :riak_core_apl.get_primary_apl(idx, 1, __MODULE__)

    [{index_node, _type}] = pref_list
    :riak_core_vnode_master.sync_command(index_node, {:get, k}, RiakPlayground.VNode_master)
  end
end
