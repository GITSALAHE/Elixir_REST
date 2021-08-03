defmodule QrCodeElixir.UserReader do
  
  @spec find_all_users() :: list
  def find_all_users do
    cursor = Mongo.find(:mongo, "User", %{})

    cursor
    |> Enum.to_list()
    |> handle_users_db_status()
  end

  
  @spec handle_users_db_status(list) :: list
  def handle_users_db_status(users) do
    if Enum.empty?(users) do
      []
    else
      users
    end
  end


  @spec user_by_email(%{}) :: %{}
  def user_by_email(email) do
    Mongo.find_one(:mongo, "User", %{email: email})
  end


  @spec user_by_username(%{}) :: %{}
  def user_by_username(username) do
    Mongo.find_one(:mongo, "User", %{username: username})
  end
end