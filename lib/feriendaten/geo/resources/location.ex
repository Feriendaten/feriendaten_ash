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
      constraints max_length: 255
    end

    attribute :code, :string, constraints: [max_length: 3]

    attribute :slug, :string do
      allow_nil? false
      constraints max_length: 255
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  validations do
    validate present([:name, :slug])
  end

  relationships do
    belongs_to :level, Feriendaten.Geo.Level do
      allow_nil? false
    end
  end

  actions do
    defaults [:update, :destroy]

    read :read do
      # add this if you’re overriding the primary read
      primary? true
      pagination offset?: true, keyset?: true
    end

    create(:create) do
      argument :level_id, :string
      primary? true
      change manage_relationship(:level_id, :level, type: :append_and_remove)
    end
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
