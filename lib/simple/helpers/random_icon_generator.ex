defmodule Simple.Helpers.Generator do
  def generate do
    ~w(blue green light_blue pink yellow) |> Enum.random
  end
end
