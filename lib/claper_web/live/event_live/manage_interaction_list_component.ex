defmodule ClaperWeb.EventLive.ManageInteractionListComponent do
  use ClaperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 border border-gray-200 rounded-2xl p-2">
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
        <span class="font-bold text-sm text-[#140553]">{gettext("Interactions")}</span>
      </div>

      <div
        :if={length(@interactions) == 0}
        class="flex flex-col items-center justify-center text-gray-400 py-8"
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
        <div class={[
          "flex items-center gap-2 overflow-hidden pl-2 pr-3 py-2 rounded-xl w-full",
          if(interaction.enabled,
            do: "bg-gray-100 border-b-2 border-accent",
            else: "bg-white border border-gray-200"
          )
        ]}>
          <div class={[
            "flex items-center justify-center rounded-full w-[42px] h-[41px] shrink-0",
            if(interaction.enabled, do: "bg-white", else: "bg-gray-100")
          ]}>
            <%= case interaction do %>
              <% %Claper.Polls.Poll{} -> %>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5 text-gray-700"
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
              <% %Claper.Forms.Form{} -> %>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5 text-gray-700"
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
              <% %Claper.Embeds.Embed{} -> %>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="2"
                  stroke="currentColor"
                  class="h-5 w-5 text-gray-700"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M14.25 9.75L16.5 12l-2.25 2.25m-4.5 0L7.5 12l2.25-2.25M6 20.25h12A2.25 2.25 0 0020.25 18V6A2.25 2.25 0 0018 3.75H6A2.25 2.25 0 003.75 6v12A2.25 2.25 0 006 20.25z"
                  />
                </svg>
              <% %Claper.Quizzes.Quiz{} -> %>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="2"
                  stroke="currentColor"
                  class="h-5 w-5 text-gray-700"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                  />
                </svg>
              <% _ -> %>
            <% end %>
          </div>

          <div class="flex-1 min-w-0">
            <p class="font-bold text-sm text-gray-800 leading-snug truncate">
              {interaction.title}
            </p>
            <p class="text-xs text-gray-500 leading-tight truncate">
              {type_label(interaction)}
            </p>
          </div>

          <.link
            patch={edit_path(@event_code, interaction)}
            class="flex items-center justify-center rounded-full w-[42px] h-[41px] shrink-0 border border-[#140553] text-[#140553]"
          >
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20" fill="none">
              <path
                d="M3.33301 17.4998H16.6663M4.72134 10.989C4.36602 11.3451 4.16643 11.8276 4.16634 12.3306V14.9998H6.85217C7.35551 14.9998 7.83801 14.7998 8.19384 14.4431L16.1105 6.52229C16.4657 6.16612 16.6652 5.68364 16.6652 5.18063C16.6652 4.67761 16.4657 4.19513 16.1105 3.83896L15.3288 3.05563C15.1526 2.87925 14.9432 2.73935 14.7129 2.64393C14.4825 2.54851 14.2355 2.49943 13.9862 2.49951C13.7368 2.49959 13.4899 2.54882 13.2596 2.64438C13.0292 2.73995 12.82 2.87998 12.6438 3.05646L4.72134 10.989Z"
                stroke="#140553"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
          </.link>

          <input
            type="checkbox"
            class="toggle toggle-sm shrink-0 bg-gray-200 border-gray-300 [--tglbg:white] checked:bg-white checked:border-accent checked:[--tglbg:var(--color-accent)]"
            checked={interaction.enabled}
            phx-click={toggle_event(interaction)}
            phx-value-id={interaction.id}
          />
        </div>
      <% end %>
    </div>
    """
  end

  defp type_label(%Claper.Polls.Poll{}), do: gettext("Poll")
  defp type_label(%Claper.Forms.Form{}), do: gettext("Form")
  defp type_label(%Claper.Embeds.Embed{}), do: gettext("Web content")
  defp type_label(%Claper.Quizzes.Quiz{}), do: gettext("Quiz")
  defp type_label(_), do: ""

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
