defmodule IfsBq do
  def start() do
    { :ok, _data_handler_pid } = IfsBq.DataHandler.start(:ifs_data_handler)
    { :ok, _dispatcher_pid } = IfsBq.Register.start(:ifs_register)
    { :ok, _http_interface_pid } = Plug.Adapters.Cowboy.http IfsQ.HttpInterface, [], port: 5922, ref: :ifs_bridge_q_endpoint
  end

  def stop() do
    Plug.Adapters.Cowboy.shutdown :ifs_bridge_q_endpoint
    IfsBq.Register.stop()
    IfsBq.DataHandler.stop()
  end
end
