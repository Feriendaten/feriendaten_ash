defmodule Feriendaten.Legacy.LegacyLocation do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "legacy_locations"
    repo Feriendaten.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :legacy_id, :integer do
      allow_nil? false
    end

    attribute :legacy_name, :string do
      allow_nil? false
      constraints max_length: 512
    end

    attribute :legacy_slug, :string do
      allow_nil? false
      constraints max_length: 512
    end

    attribute :legacy_parent_id, :integer
  end

  validations do
    validate present([:legacy_id, :legacy_name, :legacy_slug])
  end

  relationships do
    belongs_to :location, Feriendaten.Geo.Location do
      allow_nil? false
    end
  end

  actions do
    defaults [:read]

    create(:create) do
      argument :location_id, :string
      primary? true
      change manage_relationship(:location_id, :location, type: :append_and_remove)
    end
  end
end
