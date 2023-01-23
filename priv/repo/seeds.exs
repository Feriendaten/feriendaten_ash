# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# For developers:
# mix ash_postgres.drop && mix ash_postgres.create && mix ash_postgres.migrate && mix run priv/repo/seeds.exs

require Ash.Query

levels_attributes = [
  %{id: 1, name: "Land", position: 1},
  %{id: 2, name: "Bundesland", position: 2},
  %{id: 3, name: "Landkreis", position: 3},
  %{id: 4, name: "Stadt", position: 4},
  %{id: 5, name: "Schule", position: 5}
]

for level_attributes <- levels_attributes do
  Feriendaten.Geo.Level
  |> Ash.Changeset.for_create(:create, level_attributes)
  |> Feriendaten.Geo.create!()
end

{:ok, body} = File.read(File.cwd!() <> "/priv/repo/seeds.d/locations.json")
seed_locations = Jason.decode!(body)

for seed_location <- seed_locations do
  level_slug =
    Enum.filter(levels_attributes, fn x -> x.id == seed_location["level_id"] end)
    |> hd
    |> Map.get(:name)
    |> String.downcase()

  level =
    Feriendaten.Geo.Level
    |> Ash.Query.filter(contains(slug, ^level_slug))
    |> Feriendaten.Geo.read!()
    |> hd()

  location =
    Feriendaten.Geo.Location
    |> Ash.Changeset.for_create(:create, %{
      name: seed_location["name"],
      code: seed_location["code"],
      slug: seed_location["slug"],
      level_id: level.id
    })
    |> Feriendaten.Geo.create!()

  legacy_location =
    Feriendaten.Legacy.LegacyLocation
    |> Ash.Changeset.for_create(:create, %{
      legacy_id: seed_location["legacy_id"],
      legacy_name: seed_location["legacy_name"],
      legacy_slug: seed_location["legacy_slug"],
      legacy_parent_id: seed_location["legacy_parent_id"],
      location_id: location.id
    })
    |> Feriendaten.Legacy.create!()
end
