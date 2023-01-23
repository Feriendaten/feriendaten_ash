defmodule Feriendaten.Geo.Level do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "levels"
    repo Feriendaten.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  changes do
    change fn changeset, _ ->
      if Ash.Changeset.changing_attribute?(changeset, :name) do
        value = Ash.Changeset.get_attribute(changeset, :name)
        Ash.Changeset.force_change_attribute(changeset, :slug, make_slug(value))
      else
        changeset
      end
    end
  end

  identities do
    identity :unique_slug, [:slug]
    identity :unique_name, [:name]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :slug, :string

    attribute :position, :integer do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    # `has_many` means that the destination attribute is not unique, therefore many related records could exist.
    # We assume that the destination attribute is `representative_id` based
    # on the module name of this resource and that the source attribute is `id`.
    has_many :locations, Feriendaten.Geo.Location
  end

  defp make_slug(value) do
    value
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.replace(~r/--/, "-")
  end
end
