defmodule Feriendaten.Geo.Location do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "locations"
    repo Feriendaten.Repo
  end

  identities do
    identity :unique_slug, [:slug]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :code, :string

    attribute :slug, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :level, Feriendaten.Geo.Level do
      attribute_writable? true
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  # changes do
  #   change fn changeset, _ ->
  #     if Ash.Changeset.changing_attribute?(changeset, :name) do
  #       value = Ash.Changeset.get_attribute(changeset, :name)
  #       Ash.Changeset.force_change_attribute(changeset, :slug, make_slug(value))
  #     else
  #       changeset
  #     end
  #   end
  # end

  # defp make_slug(value) do
  #   value
  #   |> String.downcase()
  #   |> String.replace(~r/[^a-z0-9]+/, "-")
  #   |> String.replace(~r/--/, "-")
  # end
end
