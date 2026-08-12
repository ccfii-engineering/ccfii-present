defmodule ClaperWeb.AdminLive.ModalComponent do
  use ClaperWeb, :live_component
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class={["modal", if(@show, do: "modal-open")]}
      role="dialog"
      aria-labelledby={"#{@id}-title"}
      aria-modal="true"
      phx-remove={hide_modal(@id)}
    >
      <div class={["modal-box", @size_class]}>
        <div class="flex items-start gap-4">
          <%= if @icon do %>
            <div class={[
              "flex-shrink-0 flex items-center justify-center h-10 w-10 rounded-full",
              @icon_bg_class
            ]}>
              <i class={"fas #{@icon} #{@icon_text_class}"}></i>
            </div>
          <% end %>

          <div class={if(@icon, do: "flex-1", else: "w-full")}>
            <h3 class="text-lg font-bold" id={"#{@id}-title"}>
              {@title}
            </h3>
            <%= if @description do %>
              <p class="py-2 text-sm text-neutral-400">
                {@description}
              </p>
            <% end %>

            <%= if @content do %>
              <div class="mt-2">
                {render_slot(@content)}
              </div>
            <% end %>
          </div>
        </div>

        <div class="modal-action">
          <%= if @cancel_action do %>
            <button type="button" phx-click="hide" phx-target={@myself} class="btn btn-ghost">
              {@cancel_action}
            </button>
          <% end %>

          <%= if @confirm_action do %>
            <button
              type="button"
              phx-click="confirm"
              phx-target={@myself}
              class={["btn", @confirm_class]}
            >
              {@confirm_action}
            </button>
          <% end %>

          <%= if @custom_actions do %>
            {render_slot(@custom_actions)}
          <% end %>
        </div>
      </div>
      <div class="modal-backdrop" phx-click="hide" phx-target={@myself}>
        <button>close</button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, show: false)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:show, fn -> false end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:icon_bg_class, fn -> "bg-error" end)
      |> assign_new(:icon_text_class, fn -> "text-error-content" end)
      |> assign_new(:description, fn -> nil end)
      |> assign_new(:content, fn -> [] end)
      |> assign_new(:confirm_action, fn -> nil end)
      |> assign_new(:confirm_class, fn -> "btn-error text-error-content" end)
      |> assign_new(:cancel_action, fn -> "Cancel" end)
      |> assign_new(:custom_actions, fn -> [] end)
      |> assign_new(:size_class, fn -> "max-w-lg" end)

    {:ok, socket}
  end

  @impl true
  def handle_event("hide", _params, socket) do
    send(self(), {:modal_cancelled, socket.assigns.id})
    {:noreply, assign(socket, show: false)}
  end

  def handle_event("confirm", _params, socket) do
    send(self(), {:modal_confirmed, socket.assigns.id})
    {:noreply, assign(socket, show: false)}
  end

  # Public API for controlling the modal
  def show_modal(js \\ %JS{}, modal_id) do
    js
    |> JS.show(to: "##{modal_id}")
    |> JS.add_class("animate-fade-in", to: "##{modal_id}")
  end

  def hide_modal(js \\ %JS{}, modal_id) do
    js
    |> JS.add_class("animate-fade-out", to: "##{modal_id}")
    |> JS.hide(to: "##{modal_id}", transition: "animate-fade-out", time: 200)
  end

  # Preset configurations for common modal types
  def delete_modal_config(title, description) do
    %{
      icon: "fa-exclamation-triangle",
      icon_bg_class: "bg-error",
      icon_text_class: "text-error-content",
      title: title,
      description: description,
      confirm_action: "Delete",
      confirm_class: "btn-error text-error-content",
      cancel_action: "Cancel"
    }
  end

  def warning_modal_config(title, description) do
    %{
      icon: "fa-exclamation-triangle",
      icon_bg_class: "bg-warning/15",
      icon_text_class: "text-warning",
      title: title,
      description: description,
      confirm_action: "Continue",
      confirm_class: "btn-warning text-warning-content",
      cancel_action: "Cancel"
    }
  end

  def info_modal_config(title, description) do
    %{
      icon: "fa-info-circle",
      icon_bg_class: "bg-info/15",
      icon_text_class: "text-info",
      title: title,
      description: description,
      confirm_action: "OK",
      confirm_class: "btn-info text-info-content",
      cancel_action: nil
    }
  end
end
