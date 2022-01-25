defmodule Pongdom.RequestWorker do
  use Oban.Worker, queue: :requests
  import Pongdom.Helpers.RequestHelper
  alias Pongdom.Accounts
  alias Pongdom.RequestAssetDispatcherWorker
  alias Pongdom.Repo

  def build(%Accounts.Request{id: id, user_id: user_id, uri: uri}) do
    new(%{request_id: id, user_id: user_id, request_uri: uri})
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "request_uri" => request_uri} = args}) do
    parsed_uri = URI.parse(request_uri)

    rate_limiting = Accounts.get_domain_rate_limiting(user_id, parsed_uri.host)
    scale_ms = if rate_limiting != nil, do: rate_limiting.scale_ms, else: 60_000
    limit = if rate_limiting != nil, do: rate_limiting.limit, else: 20

    case Hammer.check_rate("request:#{parsed_uri.host}", scale_ms, limit) do
      {:allow, _count} ->
        perform_request(args)
        :ok
      {:deny, _limit} ->
        {:snooze, Kernel.trunc(scale_ms / limit / 1000)}
    end
  end

  defp perform_request(%{
      "user_id" => user_id,
      "request_id" => request_id,
      "request_uri" => request_uri
    }) do

    {time, response} = measure_response(request_uri)

    case(response) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        insert_response = build_success_record(request_id, status_code, time) |> Repo.insert!

        %{
          user_id: user_id,
          request_response_id: insert_response.id,
          request_uri: request_uri,
          html: body
        }
        |> RequestAssetDispatcherWorker.new() |> Oban.insert()

      {:error, data} ->
        build_error_record(request_id, data.reason, time) |> Repo.insert!
    end
  end

  defp build_success_record(request_id, status_code, time) do
    %Accounts.RequestResponse {
      request_id: request_id,
      http_response_code: status_code,
      response_time: time
    }
  end

  defp build_error_record(request_id, error, time) do
    %Accounts.RequestResponse {
      request_id: request_id,
      httpoison_error_slug: Atom.to_string(error),
      response_time: time
    }
  end
end
