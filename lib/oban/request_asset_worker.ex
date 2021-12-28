defmodule Pongdom.RequestAssetWorker do
    use Oban.Worker, queue: :request_assets

    alias Pongdom.Accounts
  
    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"user_id" => user_id, "request_response_id" => request_response_id, "request_uri" => request_uri, "request_asset_uri" => request_asset_uri} = args}) do
      IO.puts "asset request"
      parsed_uri = URI.parse(request_uri)

      rate_limiting = Accounts.get_domain_rate_limiting(user_id, parsed_uri.host)
      
      scale_ms = if rate_limiting != nil do
        rate_limiting.scale_ms
      else
        60_000
      end
  
      limit = if rate_limiting != nil do
        rate_limiting.limit
      else
        20
      end

      case Hammer.check_rate("request:#{parsed_uri.host}", scale_ms, limit) do
        {:allow, _count} ->
          perform_asset_request(args)
          :ok
        {:deny, _limit} ->
          IO.puts "deny"
          {:snooze, Kernel.trunc(scale_ms / limit / 1000)}
      end
    end

    defp perform_asset_request(%{"user_id" => user_id, "request_response_id" => request_response_id, "request_uri" => request_uri, "request_asset_uri" => request_asset_uri}) do
      {time, response} = measure_response(merge_asset_uri(request_uri, request_asset_uri))
      
      new_record = case(response) do
        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          %Pongdom.Accounts.RequestAssetResponse{request_response_id: request_response_id, http_response_code: status_code, response_time: time}
        {:error, data} ->
          %Pongdom.Accounts.RequestAssetResponse{request_response_id: request_response_id, httpoison_error_slug: Atom.to_string(data.reason), response_time: time}
      end
      
      Pongdom.Repo.insert new_record
    end
    
    defp measure_response(uri) do
      (fn (uri) ->
        HTTPoison.get(uri)
      end)
      |> :timer.tc([uri])
    end

    defp merge_asset_uri(request_uri, request_asset_uri) do
        URI.merge(URI.parse(request_uri), request_asset_uri)
    end
  end