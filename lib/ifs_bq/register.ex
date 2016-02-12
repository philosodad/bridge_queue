defmodule IfsBq.Register do
  use GenServer

  def start(name) do
    GenServer.start(IfsBq.Register, nil, name: name)
  end

  def stop() do
  end

  def init() do
    {:ok, Map.new}
  end

  def handle_call({:shard_register, shard_id}, _, state) do
    {:ok, pid, state} = pid_for(shard_id, state)
  end

  defp pid_for(shard_id, state) do
    Map.fetch(state, shard_id)
    |> return_living_pid(shard_id, state) 
  end

  defp return_living_pid(:error, shard_id, state), do: make_a_new_pusher(state, shard_id)

  defp return_living_pid({:ok, pid}, shard_id, state) do
    case Process.alive? pid do
      true -> {:ok, pid, state}
      false -> make_a_new_pusher(shard_id, state)
    end
  end
    
  defp make_a_new_pusher(shard_id, state) do
    {:ok, pid} = IfsQ.Pusher.start(process_identifier(shard_id))
    pid_for(shard_id, Map.put(state, shard_id, pid))
  end

  defp process_identifier(shard_id), do: shard_id |> (&("ifs_pusher_" <> &1)).() |> String.to_atom
end

