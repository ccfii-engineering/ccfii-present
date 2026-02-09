defmodule ClaperWeb.EventLive.ManagerSettingsComponent do
  use ClaperWeb, :live_component

  def render(assigns) do
    assigns = assigns |> assign_new(:show_shortcut, fn -> true end)

    ~H"""
    <div class="flex flex-col h-full">
      <!-- Interactions Options Section -->
      <div class="px-4 py-3 border-b border-gray-200">
        <div class="flex items-center gap-x-2 font-semibold text-base text-gray-700">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-500"
          >
            <path d="M6.111 11.89A5.5 5.5 0 1 1 15.501 8 .75.75 0 0 0 17 8a7 7 0 1 0-11.95 4.95.75.75 0 0 0 1.06-1.06Z" />
            <path d="M8.232 6.232a2.5 2.5 0 0 0 0 3.536.75.75 0 1 1-1.06 1.06A4 4 0 1 1 14 8a.75.75 0 0 1-1.5 0 2.5 2.5 0 0 0-4.268-1.768Z" />
            <path d="M10.766 7.51a.75.75 0 0 0-1.37.365l-.492 6.861a.75.75 0 0 0 1.204.65l1.043-.799.985 3.678a.75.75 0 0 0 1.45-.388l-.978-3.646 1.292.204a.75.75 0 0 0 .74-1.16l-3.874-5.764Z" />
          </svg>
          <span>{gettext("Interactions Options")}</span>
        </div>
      </div>
      <div class="px-4 py-3 space-y-2 border-b border-gray-200">

        <%= case @current_interaction do %>
          <% %Claper.Polls.Poll{} -> %>
            <div class="flex space-x-2 space-y-1.5 items-center mt-1.5">
              <ClaperWeb.Component.Input.check_button
                key={:poll_visible}
                checked={@state.poll_visible}
                shortcut={if @create == nil, do: "Z", else: nil}
              >
                <svg
                  :if={@state.poll_visible}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4h1m4 0h13" /><path d="M4 4v10a2 2 0 0 0 2 2h10m3.42 -.592c.359 -.362 .58 -.859 .58 -1.408v-10" /><path d="M12 16v4" /><path d="M9 20h6" /><path d="M8 12l2 -2m4 0l2 -2" /><path d="M3 3l18 18" />
                </svg>

                <svg
                  :if={!@state.poll_visible}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4l18 0" /><path d="M4 4v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2 -2v-10" /><path d="M12 16l0 4" /><path d="M9 20l6 0" /><path d="M8 12l3 -3l2 2l3 -3" />
                </svg>

                <span :if={@state.poll_visible}>
                  {gettext("Hide results on presentation")}
                </span>
                <span :if={!@state.poll_visible}>
                  {gettext("Show results on presentation")}
                </span>
                <code
                  :if={@show_shortcut}
                  class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
                >
                  z
                </code>
                <div :if={!@show_shortcut}></div>
              </ClaperWeb.Component.Input.check_button>
            </div>
          <% %Claper.Quizzes.Quiz{} -> %>
            <div class="grid grid-cols-1 space-y-1.5 items-center mt-1.5">
              <ClaperWeb.Component.Input.check_button
                key={:quiz_show_results}
                checked={@current_interaction.show_results}
                shortcut={if @create == nil, do: "Z", else: nil}
              >
                <svg
                  :if={@current_interaction.show_results}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4h1m4 0h13" /><path d="M4 4v10a2 2 0 0 0 2 2h10m3.42 -.592c.359 -.362 .58 -.859 .58 -1.408v-10" /><path d="M12 16v4" /><path d="M9 20h6" /><path d="M8 12l2 -2m4 0l2 -2" /><path d="M3 3l18 18" />
                </svg>

                <svg
                  :if={!@current_interaction.show_results}
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="h-6 w-6"
                >
                  <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 4l18 0" /><path d="M4 4v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2 -2v-10" /><path d="M12 16l0 4" /><path d="M9 20l6 0" /><path d="M8 12l3 -3l2 2l3 -3" />
                </svg>

                <span :if={@current_interaction.show_results}>
                  {gettext("Hide results on presentation")}
                </span>
                <span :if={!@current_interaction.show_results}>
                  {gettext("Show results on presentation")}
                </span>
                <code
                  :if={@show_shortcut}
                  class="px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg"
                >
                  z
                </code>
                <div :if={!@show_shortcut}></div>
              </ClaperWeb.Component.Input.check_button>
              <div>
                <ClaperWeb.Component.Input.check_button
                  disabled={!@current_interaction.show_results}
                  key={:review_quiz_questions}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    class="w-6 h-6"
                  >
                    <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 13a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v6a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" /><path d="M15 9a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v10a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" /><path d="M9 5a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v14a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" /><path d="M4 20h14" />
                  </svg>

                  <span>
                    {gettext("Review questions")}
                  </span>
                  <div></div>
                </ClaperWeb.Component.Input.check_button>
              </div>
              <div class="grid grid-cols-2 gap-2">
                <ClaperWeb.Component.Input.check_button
                  disabled={!@current_interaction.show_results}
                  key={:prev_quiz_question}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    class="w-6 h-6"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z"
                      clip-rule="evenodd"
                    />
                  </svg>

                  <span>
                    {gettext("Previous")}
                  </span>
                </ClaperWeb.Component.Input.check_button>
                <ClaperWeb.Component.Input.check_button
                  disabled={!@current_interaction.show_results}
                  key={:next_quiz_question}
                >
                  <span>
                    {gettext("Next")}
                  </span>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    class="w-6 h-6"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </ClaperWeb.Component.Input.check_button>
              </div>
            </div>
          <% nil -> %>
            <p class="text-gray-400 italic mt-1.5">No interaction enabled</p>
          <% _ -> %>
            <p class="text-gray-400 italic mt-1.5">No settings available for this interaction</p>
        <% end %>

      </div>

      <!-- Presentation Settings Section -->
      <div class="px-4 py-3 border-b border-gray-200 space-y-2">
        <.toggle_row
          label={if @state.join_screen_visible, do: gettext("Hide instructions to join"), else: gettext("Show instructions to join")}
          checked={@state.join_screen_visible}
          key={:join_screen_visible}
          shortcut={if @create == nil, do: "Q", else: nil}
          show_shortcut={@show_shortcut}
        />
        <.toggle_row
          label={if @state.chat_visible, do: gettext("Hide messages"), else: gettext("Show messages")}
          checked={@state.chat_visible}
          key={:chat_visible}
          shortcut={if @create == nil, do: "W", else: nil}
          show_shortcut={@show_shortcut}
        />
        <.toggle_row
          label={if @state.show_only_pinned, do: gettext("Show all messages"), else: gettext("Show pinned messages")}
          checked={@state.show_only_pinned}
          key={:show_only_pinned}
          shortcut={if @create == nil, do: "E", else: nil}
          disabled={!@state.chat_visible}
          show_shortcut={@show_shortcut}
        />
        <.toggle_row
          label={if @state.chat_enabled, do: gettext("Disable messages"), else: gettext("Enable messages")}
          checked={@state.chat_enabled}
          key={:chat_enabled}
          shortcut={if @create == nil, do: "A", else: nil}
          show_shortcut={@show_shortcut}
        />
        <.toggle_row
          label={if @state.anonymous_chat_enabled, do: gettext("Reject anonymous messages"), else: gettext("Allow anonymous messages")}
          checked={@state.anonymous_chat_enabled}
          key={:anonymous_chat_enabled}
          shortcut={if @create == nil, do: "S", else: nil}
          disabled={!@state.chat_enabled}
          show_shortcut={@show_shortcut}
        />
      </div>

      <!-- Attendees Settings Section -->
      <div class="px-4 py-3 border-b border-gray-200">
        <div class="flex items-center gap-x-2 font-semibold text-base text-gray-700 mb-3">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 text-gray-500"
          >
            <path d="M8 16.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z" />
            <path
              fill-rule="evenodd"
              d="M4 4a3 3 0 0 1 3-3h6a3 3 0 0 1 3 3v12a3 3 0 0 1-3 3H7a3 3 0 0 1-3-3V4Zm4-1.5v.75c0 .414.336.75.75.75h2.5a.75.75 0 0 0 .75-.75V2.5h1A1.5 1.5 0 0 1 14.5 4v12a1.5 1.5 0 0 1-1.5 1.5H7A1.5 1.5 0 0 1 5.5 16V4A1.5 1.5 0 0 1 7 2.5h1Z"
              clip-rule="evenodd"
            />
          </svg>
          <span>{gettext("Attendees settings")}</span>
        </div>
        <div class="space-y-2">
          <.toggle_row
            label={if @state.message_reaction_enabled, do: gettext("Disable reactions"), else: gettext("Enable reactions")}
            checked={@state.message_reaction_enabled}
            key={:message_reaction_enabled}
            shortcut={if @create == nil, do: "D", else: nil}
            show_shortcut={@show_shortcut}
          />
          <.toggle_row
            label={if @state.show_attendee_count, do: gettext("Hide attendee count"), else: gettext("Show attendee count")}
            checked={@state.show_attendee_count}
            key={:show_attendee_count}
            shortcut={if @create == nil, do: "R", else: nil}
            show_shortcut={@show_shortcut}
          />
        </div>
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

  defp toggle_row(assigns) do
    ~H"""
    <div class={"flex items-center justify-between py-1 #{if @disabled, do: "opacity-50"}"}>
      <span class="text-sm text-gray-700">{@label}</span>
      <div class="flex items-center gap-x-2">
        <code
          :if={@show_shortcut && @shortcut}
          class="px-1.5 py-0.5 text-xs font-medium text-gray-500 bg-gray-100 rounded"
        >
          {@shortcut}
        </code>
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
