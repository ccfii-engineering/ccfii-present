defmodule ClaperWeb.EventLive.Join do
  use ClaperWeb, :live_view

  on_mount(ClaperWeb.AttendeeLiveAuth)

  @impl true
  def mount(params, session, socket) do
    with %{"locale" => locale} <- session do
      Gettext.put_locale(ClaperWeb.Gettext, locale)
    end

    event_not_found = gettext("Event doesn't exist")

    join_error =
      if Phoenix.Flash.get(socket.assigns.flash, :error) == event_not_found,
        do: event_not_found

    socket = assign(socket, :join_error, join_error)

    if params["disconnected_from"] do
      try do
        event = Claper.Events.get_event!(params["disconnected_from"])
        {:ok, socket |> assign(:last_event, event)}
      rescue
        _ -> {:ok, socket |> assign(:last_event, nil)}
      end
    else
      {:ok, socket |> assign(:last_event, nil)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("join", %{"event" => %{"code" => code}}, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/e/#{String.downcase(code)}")}
  end

  defp apply_action(socket, :join, _params) do
    socket
    |> redirect(to: "/")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Join"))
    |> assign(:event, nil)
  end
end
