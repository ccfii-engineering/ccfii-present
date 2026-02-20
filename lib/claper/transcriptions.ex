defmodule Claper.Transcriptions do
  @moduledoc """
  The Transcriptions context.
  """

  import Ecto.Query
  alias Claper.Repo
  alias Claper.Transcriptions.Transcription

  def list_transcriptions(presentation_file_id) do
    from(t in Transcription,
      where: t.presentation_file_id == ^presentation_file_id,
      order_by: [asc: t.inserted_at]
    )
    |> Repo.all()
  end

  def get_recent_transcriptions(presentation_file_id, limit \\ 5) do
    from(t in Transcription,
      where: t.presentation_file_id == ^presentation_file_id,
      order_by: [desc: t.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
    |> Enum.reverse()
  end

  def create_transcription(attrs) do
    %Transcription{}
    |> Transcription.changeset(attrs)
    |> Repo.insert()
  end

  def delete_transcriptions_for_presentation(presentation_file_id) do
    from(t in Transcription, where: t.presentation_file_id == ^presentation_file_id)
    |> Repo.delete_all()
  end

  def broadcast_transcription(event_uuid, transcription) do
    Phoenix.PubSub.broadcast(
      Claper.PubSub,
      "event:#{event_uuid}",
      {:transcription_created, transcription}
    )
  end
end
