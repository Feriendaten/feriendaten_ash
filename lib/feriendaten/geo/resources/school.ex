defmodule Feriendaten.Geo.School do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "schools"
    repo Feriendaten.Repo
  end

  actions do
    defaults [:update, :destroy]

    read :read do
      # add this if you’re overriding the primary read
      primary? true
      pagination offset?: true, keyset?: true
    end

    create(:create) do
      argument :location_id, :string
      primary? true
      change manage_relationship(:location_id, :location, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :line1, :string do
      allow_nil? false
    end

    attribute :street, :string

    attribute :zip_code, :string do
      allow_nil? false
    end

    attribute :city, :string do
      allow_nil? false
    end

    attribute :email, :string
    attribute :url, :string
    attribute :phone, :string
    attribute :fax, :string
    attribute :lat, :float
    attribute :lon, :float
    attribute :school_type, :string

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  validations do
    validate present([:line1, :zip_code, :city])
  end

  relationships do
    belongs_to :location, Feriendaten.Geo.Location do
      allow_nil? false
    end
  end
end
