defmodule Pongdom.RequestWorker do
  use Oban.Worker, queue: :requests
  alias Pongdom.Accounts
  alias Pongdom.Accounts.{Request,RequestResponse}
  alias Pongdom.RequestAssetDispatcherWorker
  alias Pongdom.Repo

  def build(%Request{id: id, user_id: user_id, uri: uri}) do
    new(%{request_id: id, user_id: user_id, request_uri: uri})
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "request_uri" => request_uri} = args}) do
    parsed_uri = URI.parse(request_uri)

    rate_limiting = Accounts.get_domain_rate_limiting(user_id, parsed_uri.host)
    IO.inspect rate_limiting

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

    IO.puts "limit:#{limit}"

    case Hammer.check_rate("request:#{parsed_uri.host}", scale_ms, limit) do
      {:allow, _count} ->
        perform_request(args)
        :ok
      {:deny, _limit} ->
        {:snooze, Kernel.trunc(scale_ms / limit / 1000)}
    end
  end

  defp perform_request(%{"user_id" => user_id, "request_id" => request_id, "request_uri" => request_uri} = args) do
    {time, response} = measure_response(request_uri)

    case(response) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:ok, insert_response} = %RequestResponse{request_id: request_id, http_response_code: status_code, response_time: time} |> Repo.insert

        %{user_id: user_id, request_response_id: insert_response.id, request_uri: request_uri, html: body} |> RequestAssetDispatcherWorker.new() |> Oban.insert()
        IO.puts "meep"
      {:error, data} ->
        %RequestResponse{request_id: request_id, httpoison_error_slug: Atom.to_string(data.reason), response_time: time}
        |> Repo.insert
    end
  end

  defp measure_response(uri) do
    (fn (uri) ->
      HTTPoison.get(uri)
    end)
    |> :timer.tc([uri])
  end
end