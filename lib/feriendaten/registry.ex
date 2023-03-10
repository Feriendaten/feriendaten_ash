defmodule Feriendaten.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Feriendaten.Geo.Level
    entry Feriendaten.Geo.Location
    entry Feriendaten.Legacy.LegacyLocation
    entry Feriendaten.Geo.School
  end
end
