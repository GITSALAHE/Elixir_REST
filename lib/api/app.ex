defmodule QrCodeElixir.Application do


  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [

      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: QrCodeElixir.UserEndpoint,
        options: Application.get_env(:api, :endPoint)[:port]
      ),

      worker(Mongo, [
        [
          name: :mongo,
          database: Application.get_env(:api, :db)[:database],
          pool_size: Application.get_env(:api, :db)[:pool_size]
        ]
      ])
    ]

    opts = [
      strategy: :one_for_one,
      name: QrCodeElixir.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end