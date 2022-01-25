defmodule Pongdom.RequestAssetDispatcherWorker do
    use Oban.Worker, queue: :request_asset_dispatcher
    import Pongdom.Helpers.ResponseParser

    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"html" => html} = args}) do
      IO.puts "Parsing assets"

      {:ok, document} = get_document(html)
      request_asset_uris = parse_link_elements(document) ++ parse_script_elements(document)

      Enum.each(request_asset_uris, fn(request_asset_uri) ->
        Map.put(args, :request_asset_uri, request_asset_uri)
        |> Pongdom.RequestAssetWorker.new()
        |> Oban.insert()
      end)

      :ok
    end

  end
