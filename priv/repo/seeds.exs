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
locations = Jason.decode!(body)

for location <- locations do
  level_slug =
    Enum.filter(levels_attributes, fn x -> x.id == location["level_id"] end)
    |> hd
    |> Map.get(:name)
    |> String.downcase()

  level =
    Feriendaten.Geo.Level
    |> Ash.Query.filter(contains(slug, ^level_slug))
    |> Feriendaten.Geo.read!()
    |> hd()

  Feriendaten.Geo.Location
  |> Ash.Changeset.for_create(:create, %{
    name: location["name"],
    code: location["code"],
    slug: location["slug"],
    level_id: level.id
  })
  |> Feriendaten.Geo.create!()
end
