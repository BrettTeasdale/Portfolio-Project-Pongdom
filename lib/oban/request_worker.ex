defmodule Pongdom.RequestWorker do
  use Oban.Worker, queue: :requests
  alias Pongdom.Accounts.{Request,RequestResponse}
  alias Pongdom.RequestAssetDispatcherWorker
  alias Pongdom.Repo

  def build(%Request{id: id, uri: uri}) do
    new(%{request_id: id, uri: uri})
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"request_id" => request_id, "uri" => uri}}) do
    {time, response} = measure_response(uri)

    case(response) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:ok, insert_response} = %RequestResponse{request_id: request_id, http_response_code: status_code, response_time: time} |> Repo.insert

        %{request_response_id: insert_response.id, uri: uri, html: body} |> RequestAssetDispatcherWorker.new() |> Oban.insert()
        IO.puts "meep"
      {:error, data} ->
        %RequestResponse{request_id: request_id, httpoison_error_slug: Atom.to_string(data.reason), response_time: time}
        |> Repo.insert
    end
    :ok
  end

  defp measure_response(uri) do
    (fn (uri) ->
      HTTPoison.get(uri)
    end)
    |> :timer.tc([uri])
  end
end