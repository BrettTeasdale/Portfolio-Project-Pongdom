defmodule Pongdom.Helpers.RequestHelper do

  def measure_response(uri) do
    (fn (uri) ->
      HTTPoison.get(uri)
    end)
    |> :timer.tc([uri])
  end

  def merge_uri(request_uri, request_asset_uri) do
    URI.merge(URI.parse(request_uri), request_asset_uri)
  end

end
