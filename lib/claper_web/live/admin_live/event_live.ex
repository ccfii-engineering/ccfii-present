defmodule ClaperWeb.AdminLive.EventLive do
  use ClaperWeb, :live_view

  alias Claper.Admin
  alias Claper.Events.Event

  @impl true
  def mount(_params, session, socket) do
    with %{"locale" => locale} <- session do
      Gettext.put_locale(ClaperWeb.Gettext, locale)
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    {events, meta} = Admin.list_events_paginated(params)

    socket
    |> assign(:page_title, gettext("Events"))
    |> assign(:event, nil)
    |> assign(:events, events)
    |> assign(:meta, meta)
    |> assign(:form, Phoenix.Component.to_form(meta))
    |> assign_new(:fields, fn ->
      [
        name: [
          label: nil,
          placeholder: gettext("Search events..."),
          type: "text",
          op: :ilike_or
        ]
      ]
    end)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New event"))
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit event"))
    |> assign(:event, Claper.Events.get_event!(id, [:user]))
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Event details"))
    |> assign(:event, Claper.Events.get_event!(id, [:user]))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Claper.Events.get_event!(id)
    {:ok, _} = Claper.Events.delete_event(event)

    {:noreply,
     socket
     |> put_flash(:info, gettext("Event deleted successfully"))
     |> push_patch(to: Flop.Phoenix.build_path(~p"/admin/events", socket.assigns.meta.flop))}
  end

  @impl true
  def handle_event("filter-events", unsigned_params, socket) do
    flop = Flop.validate!(unsigned_params, for: Event, replace_invalid_params: true)
    to = Flop.Phoenix.build_path(~p"/admin/events", flop)

    {:noreply, push_patch(socket, to: to)}
  end
end
