defmodule IfsBq.Repo.Migrations.Message do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message_body,    :string
      add :shard_id,        :string
      add :sent,            :boolean, default: false

      timestamps
    end
  end
end
