defmodule ClaperWeb.AdminLive.UserLive do
  use ClaperWeb, :live_view

  alias Claper.Admin
  alias Claper.Accounts
  alias Claper.Accounts.User

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
    {users, meta} = Admin.list_users_paginated(params)

    socket
    |> assign(:page_title, gettext("Users"))
    |> assign(:user, nil)
    |> assign(:users, users)
    |> assign(:meta, meta)
    |> assign(:form, Phoenix.Component.to_form(meta))
    |> assign_new(:fields, fn ->
      [
        email: [
          label: nil,
          placeholder: gettext("Search users..."),
          type: "text",
          op: :ilike_or
        ]
      ]
    end)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New user"))
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit user"))
    |> assign(:user, Accounts.get_user!(id) |> Claper.Repo.preload(:role))
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("User details"))
    |> assign(:user, Accounts.get_user!(id) |> Claper.Repo.preload(:role))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply,
     socket
     |> put_flash(:info, gettext("User deleted successfully"))
     |> push_patch(to: Flop.Phoenix.build_path(~p"/admin/users", socket.assigns.meta.flop))}
  end

  @impl true
  def handle_event("filter-users", unsigned_params, socket) do
    flop = Flop.validate!(unsigned_params, for: User, replace_invalid_params: true)
    to = Flop.Phoenix.build_path(~p"/admin/users", flop)

    {:noreply, push_patch(socket, to: to)}
  end
end
