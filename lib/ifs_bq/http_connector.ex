defmodule IfsQ.HttpInterface do
  use Plug.Router
  require IEx

  plug :match
  plug :dispatch

  post "/event" do
    shard_id = Map.new(conn.req_headers)["jmsxgroupid"]
    {:ok, message, _} = Plug.Conn.read_body(conn)
    GenServer.where_is(:ifs_data_handler) 
    |> GenServer.call(:write, message, shard_id) 
    GenServer.where_is(:ifs_register)
    |> GenServer.call({:shard_register, shard_id})
    send_resp(conn, 200, "#{message} receieved for #{shard_id}")
  end

end

