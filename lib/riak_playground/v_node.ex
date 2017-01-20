require Logger

defmodule RiakPlayground.VNode do
  @behaviour :riak_core_vnode

  def start_vnode(partition) do
    :riak_core_vnode_master.get_vnode_pid(partition, __MODULE__)
  end

  def init([partition]) do
    {:ok, %{partition: partition, data: %{}}}
  end

  def handle_command({:ping, v}, _sender, state) do
    Logger.debug("Received ping with value: #{v}")
    {:reply, {:pong, v + 1}, state}
  end

  def handle_command({:put, {k, v}}, _sender, %{data: data} = state) do
    Logger.debug("Received put with key #{inspect k} and value #{inspect v}")
    new_data = Map.put(data, k, v)
    {:noreply, Map.put(state, :data, new_data)}
  end

  def handle_command({:get, k}, _sender, %{data: data} = state) do
    Logger.debug("Received get with key #{inspect k}")
    {:reply, Map.get(data, k, nil), state}
  end

  def handoff_starting(_dest, state) do
    {true, state}
  end

  def handoff_cancelled(state) do
    {:ok, state}
  end

  def handoff_finished(_dest, state) do
    {:ok, state}
  end

  def handle_handoff_command(_fold_req, _sender, state) do
    {:noreply, state}
  end

  def is_empty(state) do
    {true, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def delete(state) do
    {:ok, state}
  end

  def handle_handoff_data(_bin_data, state) do
    {:reply, :ok, state}
  end

  def encode_handoff_item(_k, _v) do
  end

  def handle_coverage(_req, _key_spaces, _sender, state) do
    {:stop, :not_implemented, state}
  end

  def handle_exit(_pid, _reason, state) do
    {:noreply, state}
  end
end
