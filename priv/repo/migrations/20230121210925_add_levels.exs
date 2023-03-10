defmodule Feriendaten.Repo.Migrations.AddLevels do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:levels, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :name, :text
      add :slug, :text
      add :position, :bigint
    end
  end

  def down do
    drop table(:levels)
  end
end
