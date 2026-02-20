defmodule ClaperWeb.AudioSocket do
  use Phoenix.Socket

  channel "audio:*", ClaperWeb.AudioChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(ClaperWeb.Endpoint, "audio_token", token, max_age: 86_400) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(socket), do: "audio_socket:#{socket.assigns.user_id}"
end
