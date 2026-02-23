defmodule PatrioticDemocracyTest do
  use ExUnit.Case
  doctest PatrioticDemocracy

  test "greets the world" do
    assert PatrioticDemocracy.hello() == :world
  end
end
