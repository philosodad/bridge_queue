defmodule IfsBq.DataHandler do
  use GenServer

  def start(name) do
    {:ok, pid} = IfsBq.Repo.start_link
    GenServer.start(IfsBq.DataHandler, pid, name: name)
  end

  def stop(name) do
    this = GenServer.whereis(name)
    state = GenServer.call(this,{ :state})
    IfsBq.Repo.stop(state.repo)
    GenServer.stop(this)
  end

  def init(pid) do
    {:ok, %{repo: pid}}
  end

  def handle_call({:write, message, shard_id}, _, state) do
    IfsBq.DbConnector.add_message message, shard_id
    {:reply, :ok, state}
  end

  def handle_call({:state}, _, state) do
    {:reply, state, state}
  end

end
