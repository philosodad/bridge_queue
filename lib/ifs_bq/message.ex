defmodule IfsBq.Message do
  use Ecto.Schema
  schema "messages" do
    field :message_body, :string
    field :shard_id,     :string
    field :sent,         :boolean, default: false

    timestamps([usec: true])
  end
end
