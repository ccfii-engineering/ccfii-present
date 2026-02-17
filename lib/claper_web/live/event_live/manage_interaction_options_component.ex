defmodule ClaperWeb.EventLive.ManageInteractionOptionsComponent do
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
            d="M6.111 11.89A5.5 5.5 0 1 1 15.501 8 .75.75 0 0 0 17 8a7 7 0 1 0-11.95 4.95.75.75 0 0 0 1.06-1.06Z"
            fill="#140553"
          />
          <path
            d="M8.232 6.232a2.5 2.5 0 0 0 0 3.536.75.75 0 1 1-1.06 1.06A4 4 0 1 1 14 8a.75.75 0 0 1-1.5 0 2.5 2.5 0 0 0-4.268-1.768Z"
            fill="#140553"
          />
          <path
            d="M10.766 7.51a.75.75 0 0 0-1.37.365l-.492 6.861a.75.75 0 0 0 1.204.65l1.043-.799.985 3.678a.75.75 0 0 0 1.45-.388l-.978-3.646 1.292.204a.75.75 0 0 0 .74-1.16l-3.874-5.764Z"
            fill="#140553"
          />
        </svg>
        <span class="font-bold text-sm text-[#140553]">{gettext("Current interaction options")}</span>
      </div>

      <div class="space-y-2 px-1">
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
            <p class="text-gray-400 italic mt-1.5">{gettext("No interaction enabled")}</p>
          <% _ -> %>
            <p class="text-gray-400 italic mt-1.5 text-sm">{gettext("No settings available for this interaction")}</p>
        <% end %>
      </div>
    </div>
    """
  end
end
