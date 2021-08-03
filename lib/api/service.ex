defmodule QrCodeElixir.ServiceUtils do

  defimpl Poison.Encoder, for: BSON.ObjectId do
    def encode(id, options) do
      BSON.ObjectId.encode!(id)
      |> Poison.Encoder.encode(options)
    end
  end


  @spec endpoint_success(any) :: binary
  def endpoint_success(data) do
    Poison.encode!(%{
      "status" => 200,
      "data" => data
    })
  end

 
  @spec endpoint_error(binary) :: binary
  def endpoint_error(error_type) do
    Poison.encode!(%{
      "status" => 200,
      "fail_reason" =>
        cond do
          error_type == 'empty' -> "Empty Data"
          error_type == 'not_found' -> "Not found"
          error_type == 'missing_email' -> "Missing email"
          error_type == 'missing_username' -> "Missing username"
          error_type == 'missing_prams' -> "Missing query params"
          true -> "An expected error was occurred"
        end
    })
  end
end