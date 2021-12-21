defmodule Pongdom.RequestAssetDispatcherWorker do
    use Oban.Worker, queue: :request_asset_dispatcher
  
    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"uri" => uri, "request_response_id" => request_response_id, "html" => html} = args}) do
      IO.puts "Parsing assets"
      {:ok, document} = Floki.parse_document(html)

      parse_link_elements(document, args)
      parse_script_elements(document, args)

      :ok
    end

    defp parse_link_elements(document, %{"uri" => uri, "request_response_id" => request_response_id} = args) do
      Enum.each(Floki.find(document, "link"), fn(link_element) ->
        {_, attributes, _} = link_element

        Enum.each(attributes, fn(attribute) ->    
          dispatch_job_on_link_href_attribute(attribute, args)
        end)
      end)
    end

    defp dispatch_job_on_link_href_attribute(attribute, args) do
      case(attribute) do
        {"href", path} ->
          IO.puts "link"
          Map.put(args, :path, path) |> Pongdom.RequestAssetWorker.new() |> Oban.insert() 
      _ -> nil
      end
    end

    defp parse_script_elements(document, %{"uri" => uri, "request_response_id" => request_response_id} = args) do
      Enum.each(Floki.find(document, "script"), fn(link_element) ->
        {_, attributes, _} = link_element

        Enum.each(attributes, fn(attribute) ->    
          dispatch_job_on_script_src_attribute(attribute, args)
        end)
      end)
    end

    defp dispatch_job_on_script_src_attribute(attribute, args) do
      case(attribute) do
        {"src", path} ->
          IO.puts "script"
          Map.put(args, :path, path) |> Pongdom.RequestAssetWorker.new() |> Oban.insert() 
        _ -> nil
      end
    end
  end