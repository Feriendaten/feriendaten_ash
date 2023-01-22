# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

levels_attributes = [
  %{name: "Land", position: 1},
  %{name: "Bundesland", position: 2},
  %{name: "Landkreis", position: 3},
  %{name: "Stadt", position: 4},
  %{name: "Schule", position: 5}
]

for level_attributes <- levels_attributes do
  Feriendaten.Geo.Level
  |> Ash.Changeset.for_create(:create, level_attributes)
  |> Feriendaten.Geo.create!()
end
