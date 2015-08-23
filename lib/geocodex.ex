defmodule Geocodex do
  defstruct api_key: nil, original_address: nil, lat: nil, lng: nil, formatted_address: nil

  require HTTPotion
  require URI

  def new([api_key: api_key]) do
    %Geocodex{ api_key: api_key }
  end

  def geocode(%Geocodex{ api_key: api_key }, address) do
    case geocodio_get(address, api_key) do
      { :ok, response } -> do_parse_response(response, api_key: api_key)
      { :error, error } -> IO.puts "error: #{inspect error}"
    end
  end

  defp do_parse_response(response, [ api_key: api_key ]) do
    %{ formatted_address: formatted_address, coords: coords } = response
    { lat, lng } = coords
    %Geocodex{ api_key: api_key, lat: lat, lng: lng, formatted_address: formatted_address }
  end

  defp geocodio_get(address, api_key) do
    query_string = URI.encode_query %{ q: address, api_key: api_key }
    response = HTTPotion.get "https://api.geocod.io/v1/geocode?#{query_string}"
    result = Poison.decode! response.body

    top_result = hd result["results"]
    %{ "lat" => lat, "lng" => lng } = top_result["location"]

    { :ok, %{
        formatted_address: top_result["formatted_address"],
        coords: { lat, lng }
      }
    }
  end
end
