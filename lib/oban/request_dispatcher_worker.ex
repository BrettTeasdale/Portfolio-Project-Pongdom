defmodule Pongdom.RequestDispatcherWorker do
    use Oban.Worker, queue: :request_dispatcher
  
    @impl Oban.Worker
    def perform(_) do
      IO.puts "start job"
      requests = Pongdom.Repo.all(Pongdom.Accounts.Request)

      Enum.each(requests, fn(request) ->
        IO.puts "plop"
        request |> Pongdom.RequestWorker.build() |> Oban.insert()
      end)

      :ok
    end
  end