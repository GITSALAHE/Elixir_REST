defmodule QrCodeElixir.DBConfig do

  def list_indexes do
    Mongo.list_index_names(:mongo, "User")
    |> Enum.to_list()

    # |> IO.inspect()
  end
end