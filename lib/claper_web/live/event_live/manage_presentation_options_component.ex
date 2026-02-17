defmodule ClaperWeb.EventLive.ManagePresentationOptionsComponent do
  @moduledoc false
  use Phoenix.Component
  use Gettext, backend: ClaperWeb.Gettext

  def render(assigns) do
    assigns = assigns |> assign_new(:show_shortcut, fn -> true end)

    ~H"""
    <div class="flex flex-col gap-2 border border-gray-200 rounded-2xl p-2 bg-white shadow-lg">
      <div class="flex items-center gap-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 20 20"
          fill="none"
          class="shrink-0"
        >
          <path
            fill-rule="evenodd"
            d="M2 4.25A2.25 2.25 0 0 1 4.25 2h11.5A2.25 2.25 0 0 1 18 4.25v8.5A2.25 2.25 0 0 1 15.75 15h-3.105a3.501 3.501 0 0 0 1.1 1.677A.75.75 0 0 1 13.26 18H6.74a.75.75 0 0 1-.484-1.323A3.501 3.501 0 0 0 7.355 15H4.25A2.25 2.25 0 0 1 2 12.75v-8.5Zm1.5 0a.75.75 0 0 1 .75-.75h11.5a.75.75 0 0 1 .75.75v7.5a.75.75 0 0 1-.75.75H4.25a.75.75 0 0 1-.75-.75v-7.5Z"
            clip-rule="evenodd"
            fill="#140553"
          />
        </svg>
        <span class="font-bold text-sm text-[#140553]">{gettext("Presentation Options")}</span>
      </div>

      <div class="space-y-2 px-1">
        <.toggle_row
          label={if @state.join_screen_visible, do: gettext("Hide instructions to join"), else: gettext("Show instructions to join")}
          checked={@state.join_screen_visible}
          key={:join_screen_visible}
          shortcut={if @create == nil, do: "Q", else: nil}
          show_shortcut={@show_shortcut}
        >
          <:icon>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
              <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
            </svg>
          </:icon>
        </.toggle_row>
        <.toggle_row
          label={if @state.chat_visible, do: gettext("Hide messages"), else: gettext("Show messages")}
          checked={@state.chat_visible}
          key={:chat_visible}
          shortcut={if @create == nil, do: "W", else: nil}
          show_shortcut={@show_shortcut}
        >
          <:icon>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path fill-rule="evenodd" d="M10 3c-4.31 0-8 3.033-8 7 0 2.024.978 3.825 2.499 5.085a3.478 3.478 0 0 1-.522 1.756.75.75 0 0 0 .584 1.143 5.976 5.976 0 0 0 3.936-1.108c.487.082.99.124 1.503.124 4.31 0 8-3.033 8-7s-3.69-7-8-7Z" clip-rule="evenodd" />
            </svg>
          </:icon>
        </.toggle_row>
        <.toggle_row
          label={if @state.show_only_pinned, do: gettext("Show all messages"), else: gettext("Show pinned messages")}
          checked={@state.show_only_pinned}
          key={:show_only_pinned}
          shortcut={if @create == nil, do: "E", else: nil}
          disabled={!@state.chat_visible}
          show_shortcut={@show_shortcut}
        >
          <:icon>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="w-5 h-5"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M15 4.5l-4 4l-4 1.5l-1.5 1.5l7 7l1.5 -1.5l1.5 -4l4 -4" /><path d="M9 15l-4.5 4.5" /><path d="M14.5 4l5.5 5.5" />
            </svg>
          </:icon>
        </.toggle_row>
        <.toggle_row
          label={if @state.chat_enabled, do: gettext("Disable messages"), else: gettext("Enable messages")}
          checked={@state.chat_enabled}
          key={:chat_enabled}
          shortcut={if @create == nil, do: "A", else: nil}
          show_shortcut={@show_shortcut}
        >
          <:icon>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path fill-rule="evenodd" d="M10 2c-2.236 0-4.43.18-6.57.524C1.993 2.755 1 3.958 1 5.307v5.386c0 1.349.993 2.552 2.43 2.783 1.3.209 2.622.351 3.963.42a.75.75 0 0 1 .407.164l2.641 2.112a.75.75 0 0 0 1.184-.51l.311-2.476a.75.75 0 0 1 .663-.653c1.484-.183 2.928-.456 4.32-.814.658-.169 1.081-.8 1.081-1.49V5.307c0-1.349-.993-2.552-2.43-2.783A42.078 42.078 0 0 0 10 2ZM6.75 8a.75.75 0 0 0 0 1.5h6.5a.75.75 0 0 0 0-1.5h-6.5Zm0-3a.75.75 0 0 0 0 1.5h6.5a.75.75 0 0 0 0-1.5h-6.5Z" clip-rule="evenodd" />
            </svg>
          </:icon>
        </.toggle_row>
        <.toggle_row
          label={if @state.anonymous_chat_enabled, do: gettext("Reject anonymous messages"), else: gettext("Allow anonymous messages")}
          checked={@state.anonymous_chat_enabled}
          key={:anonymous_chat_enabled}
          shortcut={if @create == nil, do: "S", else: nil}
          disabled={!@state.chat_enabled}
          show_shortcut={@show_shortcut}
        >
          <:icon>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
              <path d="M10 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3.465 14.493a1.23 1.23 0 0 0 .41 1.412A9.957 9.957 0 0 0 10 18c2.31 0 4.438-.784 6.131-2.1.43-.333.604-.903.408-1.41a7.002 7.002 0 0 0-13.074.003Z" />
            </svg>
          </:icon>
        </.toggle_row>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :checked, :boolean, required: true
  attr :key, :atom, required: true
  attr :shortcut, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :show_shortcut, :boolean, default: true
  slot :icon, required: true

  defp toggle_row(assigns) do
    ~H"""
    <div class={[
      "flex items-center gap-2 rounded-full pl-2 pr-3 py-2 overflow-hidden transition-colors",
      if(@disabled, do: "opacity-50"),
      if(@checked, do: "bg-[#f3defa] border-b-2 border-primary", else: "bg-white border border-gray-200")
    ]}>
      <div class={[
        "flex items-center justify-center w-8 h-8 rounded-full shrink-0",
        if(@checked, do: "bg-white text-primary-500", else: "bg-gray-100 text-secondary-500")
      ]}>
        {render_slot(@icon)}
      </div>
      <span class={["flex-1 text-xs text-gray-700", if(@checked, do: "font-semibold")]}>
        {@label}
      </span>
      <div class="flex items-center gap-x-2 shrink-0">
        <kbd :if={@show_shortcut && @shortcut} class="kbd kbd-sm">
          {@shortcut}
        </kbd>
        <button
          phx-click={ClaperWeb.Component.Input.checked(@checked, @key)}
          disabled={@disabled}
          phx-value-key={@key}
          type="button"
          class={"relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none disabled:cursor-not-allowed #{if @checked, do: "bg-primary-500", else: "bg-gray-200"}"}
          role="switch"
          aria-checked={@checked}
          phx-key={@shortcut}
          phx-window-keydown={if @shortcut && not @disabled, do: ClaperWeb.Component.Input.checked(@checked, @key)}
        >
          <span class={"pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out #{if @checked, do: "translate-x-5", else: "translate-x-0"}"}>
          </span>
        </button>
      </div>
    </div>
    """
  end
end
