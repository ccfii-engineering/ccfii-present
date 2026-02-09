defmodule ClaperWeb.EventLive.ManageInteractionListComponent do
  use ClaperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-xl shadow-base h-full flex flex-col">
      <div class="px-4 py-3 border-b border-gray-200 flex items-center gap-x-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          class="w-5 h-5 text-gray-500"
        >
          <path
            fill-rule="evenodd"
            d="M10 2c-2.236 0-4.43.18-6.57.524C1.993 2.755 1 4.014 1 5.426v5.148c0 1.413.993 2.67 2.43 2.902 1.168.188 2.352.327 3.55.414.28.02.521.18.642.413l1.713 3.293a.75.75 0 0 0 1.33 0l1.713-3.293a.783.783 0 0 1 .642-.413 41.102 41.102 0 0 0 3.55-.414c1.437-.231 2.43-1.49 2.43-2.902V5.426c0-1.413-.993-2.67-2.43-2.902A41.289 41.289 0 0 0 10 2ZM6.75 6a.75.75 0 0 0 0 1.5h6.5a.75.75 0 0 0 0-1.5h-6.5Zm0 2.5a.75.75 0 0 0 0 1.5h3.5a.75.75 0 0 0 0-1.5h-3.5Z"
            clip-rule="evenodd"
          />
        </svg>
        <span class="font-semibold text-gray-700">{gettext("Interactions")}</span>
      </div>
      <div class="flex-1 overflow-y-auto p-3 space-y-2">
        <div
          :if={length(@interactions) == 0}
          class="h-full flex flex-col items-center justify-center text-gray-400 py-8"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="h-12 w-12 mb-3"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M4 12h6l-6 8h6" /><path d="M14 4h6l-6 8h6" />
          </svg>
          <p class="text-sm text-center">
            {gettext("No interactions on this slide")}
          </p>
        </div>

        <%= for interaction <- @interactions do %>
          <div class="flex items-center justify-between p-3 rounded-lg border border-gray-200 hover:border-gray-300 transition-colors">
            <div class="flex items-center gap-x-3 flex-1 min-w-0">
              <%= case interaction do %>
                <% %Claper.Polls.Poll{} -> %>
                  <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-primary text-white">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M16 8v8m-4-5v5m-4-2v2m-2 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                      />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="text-xs text-gray-500">{gettext("Poll")}</p>
                    <p class="text-sm font-medium text-gray-900 truncate">{interaction.title}</p>
                  </div>
                <% %Claper.Forms.Form{} -> %>
                  <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-primary text-white">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
                      />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="text-xs text-gray-500">{gettext("Form")}</p>
                    <p class="text-sm font-medium text-gray-900 truncate">{interaction.title}</p>
                  </div>
                <% %Claper.Embeds.Embed{} -> %>
                  <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-primary text-white">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M14.25 9.75L16.5 12l-2.25 2.25m-4.5 0L7.5 12l2.25-2.25M6 20.25h12A2.25 2.25 0 0020.25 18V6A2.25 2.25 0 0018 3.75H6A2.25 2.25 0 003.75 6v12A2.25 2.25 0 006 20.25z"
                      />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="text-xs text-gray-500">{gettext("Web content")}</p>
                    <p class="text-sm font-medium text-gray-900 truncate">{interaction.title}</p>
                  </div>
                <% %Claper.Quizzes.Quiz{} -> %>
                  <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-primary text-white">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                      />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="text-xs text-gray-500">{gettext("Quiz")}</p>
                    <p class="text-sm font-medium text-gray-900 truncate">{interaction.title}</p>
                  </div>
                <% _ -> %>
              <% end %>
            </div>
            <div class="flex items-center gap-x-2 ml-2">
              <.link
                patch={edit_path(@event_code, interaction)}
                class="p-1.5 rounded-md hover:bg-gray-100 text-gray-500 hover:text-gray-700 transition-colors"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-4 w-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="2"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                  />
                </svg>
              </.link>
              <button
                phx-click={toggle_event(interaction)}
                phx-value-id={interaction.id}
                class={"relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none #{if interaction.enabled, do: "bg-primary-500", else: "bg-gray-200"}"}
              >
                <span class={"pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out #{if interaction.enabled, do: "translate-x-5", else: "translate-x-0"}"}>
                </span>
              </button>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp edit_path(event_code, %Claper.Polls.Poll{id: id}),
    do: ~p"/e/#{event_code}/manage/edit/poll/#{id}"

  defp edit_path(event_code, %Claper.Forms.Form{id: id}),
    do: ~p"/e/#{event_code}/manage/edit/form/#{id}"

  defp edit_path(event_code, %Claper.Embeds.Embed{id: id}),
    do: ~p"/e/#{event_code}/manage/edit/embed/#{id}"

  defp edit_path(event_code, %Claper.Quizzes.Quiz{id: id}),
    do: ~p"/e/#{event_code}/manage/edit/quiz/#{id}"

  defp edit_path(event_code, _), do: ~p"/e/#{event_code}/manage"

  defp toggle_event(%Claper.Polls.Poll{enabled: true}), do: "poll-set-inactive"
  defp toggle_event(%Claper.Polls.Poll{enabled: false}), do: "poll-set-active"
  defp toggle_event(%Claper.Forms.Form{enabled: true}), do: "form-set-inactive"
  defp toggle_event(%Claper.Forms.Form{enabled: false}), do: "form-set-active"
  defp toggle_event(%Claper.Embeds.Embed{enabled: true}), do: "embed-set-inactive"
  defp toggle_event(%Claper.Embeds.Embed{enabled: false}), do: "embed-set-active"
  defp toggle_event(%Claper.Quizzes.Quiz{enabled: true}), do: "quiz-set-inactive"
  defp toggle_event(%Claper.Quizzes.Quiz{enabled: false}), do: "quiz-set-active"
  defp toggle_event(_), do: ""
end
