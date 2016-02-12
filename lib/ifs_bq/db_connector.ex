defmodule IfsBq.DbConnector do
  def add_message(message, shard_id) do
    changeset = %IfsBq.Message{message_body: message, shard_id: shard_id}
    {:ok, message} = IfsBq.Repo.insert(changeset)
  end
end
