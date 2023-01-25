# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# For developers:
# mix ash_postgres.drop && mix ash_postgres.create && mix ash_postgres.migrate && mix run priv/repo/seeds.exs

require Ash.Query

# Create levels
#
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

# Load Schools from JSON
{:ok, body} = File.read(File.cwd!() <> "/priv/repo/seeds.d/schools.json")
seed_schools = Jason.decode!(body)

# Create locations
#
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

  # Find school with location_id == seed_location["id"]
  case Enum.filter(seed_schools, fn x -> x["location_id"] == seed_location["id"] end) do
    [seed_school] ->
      Feriendaten.Geo.School
      |> Ash.Changeset.for_create(:create, %{
        line1: seed_school["line1"],
        street: seed_school["street"],
        zip_code: seed_school["zip_code"],
        city: seed_school["city"],
        email: seed_school["email"],
        url: seed_school["url"],
        phone: seed_school["phone"],
        fax: seed_school["fax"],
        lon: seed_school["lon"],
        lat: seed_school["lat"],
        school_type: seed_school["school_type"],
        location_id: location.id
      })
      |> Feriendaten.Geo.create!()

    _ ->
      nil
  end
end

# Create schools
#
# {:ok, body} = File.read(File.cwd!() <> "/priv/repo/seeds.d/schools.json")
# seed_schools = Jason.decode!(body)

# for seed_school <- seed_schools do
#   school =
#     Feriendaten.Geo.School
#     |> Ash.Changeset.for_create(:create, %{
#       line1: seed_school["line1"],
#       street: seed_school["street"],
#       zip_code: seed_school["zip_code"],
#       city: seed_school["city"],
#       email: seed_school["email"],
#       url: seed_school["url"],
#       phone: seed_school["phone"],
#       fax: seed_school["fax"],
#       lon: seed_school["lon"],
#       lat: seed_school["lat"],
#       school_type: seed_school["school_type"],
#       location_id: seed_school["location_id"]
#     })
#     |> Feriendaten.Geo.create!()
# end
