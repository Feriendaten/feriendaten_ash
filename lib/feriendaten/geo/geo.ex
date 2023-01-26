defmodule Feriendaten.Geo do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    # This defines the set of resources that can be used with this API
    registry Feriendaten.Registry
  end
end
