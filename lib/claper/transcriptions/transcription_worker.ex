defmodule Claper.Transcriptions.TranscriptionWorker do
  @moduledoc """
  GenServer that manages transcription for an active event.
  Receives audio chunks, sends them to Voxtral API, and broadcasts results.
  """

  use GenServer

  require Logger

  alias Claper.Transcriptions
  alias Claper.Transcriptions.VoxtralClient

  # Client API

  def start_link({event_uuid, presentation_file_id}) do
    GenServer.start_link(__MODULE__, {event_uuid, presentation_file_id},
      name: via(event_uuid)
    )
  end

  def push_audio(event_uuid, audio_chunk) do
    case Registry.lookup(Claper.TranscriptionRegistry, event_uuid) do
      [{pid, _}] -> GenServer.cast(pid, {:audio_chunk, audio_chunk})
      [] -> {:error, :worker_not_running}
    end
  end

  def stop(event_uuid) do
    case Registry.lookup(Claper.TranscriptionRegistry, event_uuid) do
      [{pid, _}] -> GenServer.stop(pid, :normal)
      [] -> :ok
    end
  end

  def running?(event_uuid) do
    Registry.lookup(Claper.TranscriptionRegistry, event_uuid) != []
  end

  # Server callbacks

  @impl true
  def init({event_uuid, presentation_file_id}) do
    Logger.info("TranscriptionWorker started for event #{event_uuid}")

    {:ok,
     %{
       event_uuid: event_uuid,
       presentation_file_id: presentation_file_id
     }}
  end

  @impl true
  def handle_cast({:audio_chunk, audio_data}, state) do
    Task.Supervisor.start_child(Claper.TaskSupervisor, fn ->
      process_audio(audio_data, state)
    end)

    {:noreply, state}
  end

  @impl true
  def terminate(reason, state) do
    Logger.info(
      "TranscriptionWorker stopping for event #{state.event_uuid}, reason: #{inspect(reason)}"
    )

    :ok
  end

  defp process_audio(audio_data, state) do
    config = Application.get_env(:claper, :transcription) || []
    language = config[:language]

    case VoxtralClient.transcribe(audio_data, language: language) do
      {:ok, %{text: text}} when text != "" ->
        case Transcriptions.create_transcription(%{
               text: text,
               presentation_file_id: state.presentation_file_id
             }) do
          {:ok, transcription} ->
            Transcriptions.broadcast_transcription(state.event_uuid, transcription)

          {:error, reason} ->
            Logger.error("Failed to save transcription: #{inspect(reason)}")
        end

      {:ok, %{text: ""}} ->
        :ok

      {:error, reason} ->
        Logger.error("Transcription failed: #{inspect(reason)}")
    end
  end

  defp via(event_uuid) do
    {:via, Registry, {Claper.TranscriptionRegistry, event_uuid}}
  end
end
