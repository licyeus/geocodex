defmodule GeocodexTest do
  use ExUnit.Case

  test "it returns a Geocodex" do
    assert is_map Geocodex.new(api_key: "40c7637d034f707bd6f5600c536d5c5790f0073")
  end

  test "it returns correct lat/lng for a given address string" do
    %{ lat: lat, lng: lng } = Geocodex.new(api_key: "40c7637d034f707bd6f5600c536d5c5790f0073")
                              |> Geocodex.geocode("1123 Taylor Ave N Seattle WA 98109")
    assert { lat, lng } == { 47.629095265306, -122.34623197959 }
  end

  test "it returns correct lat/lng for a different address string" do
    %{ lat: lat, lng: lng } = Geocodex.new(api_key: "40c7637d034f707bd6f5600c536d5c5790f0073")
                              |> Geocodex.geocode("620 8th Ave New York NY 10018")
    assert { lat, lng } == { 40.756208580704, -73.990299780241 }
  end

  test "it reformats the address" do
    %{ formatted_address: formatted_address } = Geocodex.new(api_key: "40c7637d034f707bd6f5600c536d5c5790f0073")
                                                |> Geocodex.geocode("1123 taylor ave n seattle wa 98109")
    assert formatted_address == "1123 Taylor Ave N, Seattle, WA 98109"
  end
end