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
          viewBox="0 0 24 24"
          fill="none"
          class="shrink-0"
        >
          <path
            d="M19.7774 4.2209C18.7569 3.19837 17.5444 2.38746 16.2097 1.83473C14.8749 1.282 13.4442 0.998334 11.9995 1.00001C5.92463 1.00001 1 5.92484 1 12C1 15.0376 2.23185 17.7883 4.2226 19.7791C5.24314 20.8016 6.45558 21.6125 7.79032 22.1653C9.12506 22.718 10.5558 23.0017 12.0005 23C18.0754 23 23 18.0752 23 12C23 8.96242 21.7682 6.21174 19.7774 4.2209ZM18.3641 18.3611C17.529 19.1976 16.537 19.8611 15.445 20.3134C14.353 20.7658 13.1824 20.9982 12.0005 20.9972C7.03 20.9972 3.00083 16.9679 3.00083 11.9973C2.9999 10.8152 3.23227 9.64463 3.68461 8.55258C4.13695 7.46054 4.80037 6.46851 5.63684 5.63337C6.47183 4.79698 7.46367 4.13359 8.55551 3.68124C9.64734 3.22888 10.8177 2.99645 11.9995 2.99726C16.9691 2.99726 20.9982 7.02658 20.9982 11.9963C20.9991 13.1782 20.7666 14.3486 20.3143 15.4405C19.862 16.5324 19.1986 17.5243 18.3622 18.3593L18.3641 18.3611Z"
            fill="#140553"
          />
          <path
            d="M17.1755 6.82391C16.4964 6.14349 15.6896 5.6039 14.8014 5.23611C13.9133 4.86831 12.9612 4.67956 11.9999 4.68067C7.9576 4.68067 4.68066 7.95774 4.68066 12.0002C4.68066 14.0215 5.50035 15.8518 6.82503 17.1766C7.50412 17.857 8.3109 18.3966 9.19905 18.7644C10.0872 19.1322 11.0393 19.3209 12.0005 19.3198C16.0429 19.3198 19.3198 16.0428 19.3198 12.0002C19.3198 9.97899 18.5001 8.14864 17.1755 6.82391ZM16.235 16.233C15.6793 16.7897 15.0192 17.2311 14.2926 17.5321C13.566 17.8332 12.7871 17.9878 12.0005 17.9872C8.69312 17.9872 6.01205 15.306 6.01205 11.9984C6.01143 11.2119 6.16605 10.4329 6.46705 9.70628C6.76804 8.97961 7.20949 8.3195 7.76609 7.76378C8.32171 7.20723 8.9817 6.76581 9.70822 6.4648C10.4347 6.1638 11.2135 6.00913 11.9999 6.00967C15.3068 6.00967 17.9878 8.69085 17.9878 11.9978C17.9884 12.7842 17.8337 13.5631 17.5327 14.2896C17.2317 15.0162 16.7903 15.6762 16.2338 16.2318L16.235 16.233Z"
            fill="#140553"
          />
          <path
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M12.2246 7.64453C14.5288 7.76135 16.362 9.66677 16.3623 12C16.3622 13.2041 15.8727 14.2962 15.084 15.085H15.085C14.6803 15.4904 14.1991 15.812 13.6699 16.0313C13.207 16.2229 12.7142 16.3323 12.2148 16.3564L12 16.3623C9.59163 16.3621 7.63795 14.4084 7.6377 12C7.63783 10.796 8.12745 9.70477 8.91602 8.91602C9.32071 8.51054 9.80178 8.18893 10.3311 7.96973C10.8603 7.75061 11.4282 7.63803 12.001 7.63867L12.2246 7.64453ZM12.001 9.16016C10.4319 9.16016 9.15918 10.4328 9.15918 12.002C9.15897 12.3747 9.23238 12.7445 9.375 13.0889C9.51768 13.4331 9.72756 13.7464 9.99121 14.0098L9.99219 14.0107C10.2556 14.2744 10.5688 14.4843 10.9131 14.627C11.2575 14.7695 11.6273 14.843 12 14.8428C13.5683 14.8425 14.8405 13.5704 14.8408 12.002C14.8411 11.6293 14.7675 11.2594 14.625 10.915C14.4823 10.5707 14.2725 10.2566 14.0088 9.99317L13.9883 9.97364C13.7291 9.71908 13.4236 9.51516 13.0879 9.37598C12.7435 9.23333 12.3738 9.15993 12.001 9.16016Z"
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
