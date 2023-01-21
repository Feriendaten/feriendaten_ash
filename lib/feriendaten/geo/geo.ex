defmodule Feriendaten.Geo do
  use Ash.Api

  resources do
    # This defines the set of resources that can be used with this API
    registry Feriendaten.Geo.Registry
  end
end
