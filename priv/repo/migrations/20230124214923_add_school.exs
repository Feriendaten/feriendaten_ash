defmodule Feriendaten.Repo.Migrations.AddSchool do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:schools, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :line1, :text, null: false
      add :street, :text
      add :zip_code, :text, null: false
      add :city, :text, null: false
      add :email, :text
      add :url, :text
      add :phone, :text
      add :fax, :text
      add :lat, :float
      add :lon, :float
      add :school_type, :text
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :location_id,
          references(:locations,
            column: :id,
            name: "schools_location_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    drop constraint(:schools, "schools_location_id_fkey")

    drop table(:schools)
  end
end
