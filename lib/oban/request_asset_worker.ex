defmodule Pongdom.RequestAssetWorker do
    use Oban.Worker, queue: :request_assets
    import Pongdom.Helpers.RequestHelper
    alias Pongdom.Accounts

    @impl Oban.Worker
    def perform(%Oban.Job{args: %{
        "user_id" => user_id,
        "request_uri" => request_uri
      } = args }) do

      IO.puts "asset request"
      parsed_uri = URI.parse(request_uri)

      rate_limiting = Accounts.get_domain_rate_limiting(user_id, parsed_uri.host)
      scale_ms = if rate_limiting != nil, do: rate_limiting.scale_ms, else: 60_000
      limit = if rate_limiting != nil, do: rate_limiting.limit, else: 20

      case Hammer.check_rate("request:#{parsed_uri.host}", scale_ms, limit) do
        {:allow, _count} ->
          perform_asset_request(args)
          :ok
        {:deny, _limit} ->
          IO.puts "deny"
          {:snooze, Kernel.trunc(scale_ms / limit / 1000)}
      end
    end

    defp perform_asset_request(%{
        "request_response_id" => request_response_id,
        "request_uri" => request_uri,
        "request_asset_uri" => request_asset_uri
      }) do

      {time, response} = merge_uri(request_uri, request_asset_uri) |> measure_response()

      new_record = case(response) do
        {:ok, %HTTPoison.Response{status_code: status_code}} ->
          build_success_record(request_response_id, status_code, time)
        {:error, data} ->
          build_error_record(request_response_id, data.reason, time)
      end

      Pongdom.Repo.insert! new_record
    end

    defp build_success_record(request_response_id, status_code, time) do
      %Accounts.RequestAssetResponse {
        request_response_id: request_response_id,
        http_response_code: status_code,
        response_time: time
      }
    end

    defp build_error_record(request_response_id, error, time) do
      %Accounts.RequestAssetResponse {
        request_response_id: request_response_id,
        httpoison_error_slug: Atom.to_string(error),
        response_time: time
      }
    end
  end
