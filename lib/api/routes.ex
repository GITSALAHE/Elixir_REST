defmodule QrCodeElixir.UserEndpoint do
 

  alias QrCodeElixir.ServiceUtils, as: ServiceUtils
  alias QrCodeElixir.UserReader, as: UserReader
  alias QrCodeElixir.UserWriter, as: UserWriter

  use Plug.Router

  plug(Plug.Logger)

  plug(:match)


  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  
  get "/users" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, ServiceUtils.endpoint_success(UserReader.find_all_users()))
  end

  # Get user by email
  post "/userEmail" do
    case conn.body_params do
      %{"email" => email} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          ServiceUtils.endpoint_success(UserReader.user_by_email(email))
        )

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, ServiceUtils.endpoint_error("missing_email"))
    end
  end

  # Get user by user name
  post "/userName" do
    case conn.body_params do
      %{"username" => username} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          ServiceUtils.endpoint_success(UserReader.user_by_username(username))
        )

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, ServiceUtils.endpoint_error("missing_username"))
    end
  end

  # Add user
  post "/addUser" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_add} ->
          case UserWriter.add_user(user_to_add) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # Delete user
  post "/deleteUser" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_delete} ->
          case UserWriter.delete_user(user_to_delete) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # Update User By Email
  post "/updateUserEmail" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_update} ->
          case UserWriter.update_user_by_email(user_to_update) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end

  # Update User By User Name
  post "/updateUserName" do
    {status, body} =
      case conn.body_params do
        %{"user" => user_to_update} ->
          case UserWriter.update_user_by_username(user_to_update) do
            {:ok, user} ->
              {
                200,
                ServiceUtils.endpoint_success(user)
              }

            {:error, _changeset} ->
              {
                200,
                ServiceUtils.endpoint_error("exception")
              }
          end

        _ ->
          {
            200,
            ServiceUtils.endpoint_error("missing_prams")
          }
      end

    send_resp(conn, status, body)
  end


  match _ do
    send_resp(conn, 404, ServiceUtils.endpoint_error("exception"))
  end
end