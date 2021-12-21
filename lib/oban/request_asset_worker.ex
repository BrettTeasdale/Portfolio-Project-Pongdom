defmodule Pongdom.RequestAssetWorker do
    use Oban.Worker, queue: :request_assets
  
    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"request_response_id" => request_response_id, "uri" => uri, "path" => path} = args}) do
      IO.puts "asset request"
      {time, response} = measure_response(get_absolute_uri(uri, path))
  
      new_record = case(response) do
        {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
          %Pongdom.Accounts.RequestAssetResponse{request_response_id: request_response_id, http_response_code: status_code, response_time: time}
        {:error, data} ->
          %Pongdom.Accounts.RequestAssetResponse{request_response_id: request_response_id, httpoison_error_slug: Atom.to_string(data.reason), response_time: time}
      end
      
      Pongdom.Repo.insert new_record
      :ok
    end
    
    defp measure_response(uri) do
      (fn (uri) ->
        HTTPoison.get(uri)
      end)
      |> :timer.tc([uri])
    end

    defp get_absolute_uri(request_uri, path) do
        request_uri <> path # @todo
    end
  end