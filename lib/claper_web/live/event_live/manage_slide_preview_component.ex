defmodule ClaperWeb.EventLive.ManageSlidePreviewComponent do
  use ClaperWeb, :live_component

  alias Claper.Presentations

  def render(assigns) do
    slide_urls = Presentations.get_slide_urls(assigns.presentation_file)
    current_slide_url = Enum.at(slide_urls, assigns.current_position)
    assigns = assign(assigns, :current_slide_url, current_slide_url)

    ~H"""
    <div class="flex flex-col h-full">
      <div class="px-4 py-3 flex items-center justify-between">
        <div class="flex items-center gap-x-2">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" class="shrink-0">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M12.0001 5.25C7.69269 5.25 4.03598 8.04402 2.74785 11.9196L2.74777 11.9198C2.72991 11.9735 2.72991 12.0315 2.74777 12.0852C4.03886 15.9589 7.69466 18.75 12.0001 18.75C16.3076 18.75 19.9642 15.956 21.2514 12.0806L21.2523 12.0778C21.2702 12.0246 21.2698 11.969 21.2527 11.9183L21.2516 11.9151C19.9606 8.04115 16.3056 5.25 12.0001 5.25ZM1.32449 11.4462C2.81043 6.97587 7.02766 3.75 12.0001 3.75C16.9706 3.75 21.1857 6.97285 22.6747 11.4409C22.7963 11.8027 22.7957 12.1934 22.6744 12.5548C21.1892 17.0247 16.9721 20.25 12.0001 20.25C7.02973 20.25 2.81362 17.0272 1.3246 12.5591L1.32449 12.5588C1.20436 12.1977 1.20434 11.8075 1.32442 11.4464" fill="#140553" />
            <path fill-rule="evenodd" clip-rule="evenodd" d="M12 9.75C11.4033 9.75 10.831 9.98705 10.409 10.409C9.98705 10.831 9.75 11.4033 9.75 12C9.75 12.5967 9.98705 13.169 10.409 13.591C10.831 14.0129 11.4033 14.25 12 14.25C12.5967 14.25 13.169 14.0129 13.591 13.591C14.0129 13.169 14.25 12.5967 14.25 12C14.25 11.4033 14.0129 10.831 13.591 10.409C13.169 9.98705 12.5967 9.75 12 9.75ZM9.34835 9.34835C10.0516 8.64509 11.0054 8.25 12 8.25C12.9946 8.25 13.9484 8.64509 14.6517 9.34835C15.3549 10.0516 15.75 11.0054 15.75 12C15.75 12.9946 15.3549 13.9484 14.6517 14.6517C13.9484 15.3549 12.9946 15.75 12 15.75C11.0054 15.75 10.0516 15.3549 9.34835 14.6517C8.64509 13.9484 8.25 12.9946 8.25 12C8.25 11.0054 8.64509 10.0516 9.34835 9.34835Z" fill="#140553" />
          </svg>
          <span class="font-bold text-sm text-[#140553]">{gettext("Preview")}</span>
        </div>
        <div class="flex items-center gap-x-2 bg-gray-100 rounded-full px-4 py-2 text-sm text-secondary-500">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 20 20" fill="none">
            <path d="M2.5 3.3335H17.5M3.33333 3.3335V11.6668C3.33333 12.1089 3.50893 12.5328 3.82149 12.8453C4.13405 13.1579 4.55797 13.3335 5 13.3335H15C15.442 13.3335 15.866 13.1579 16.1785 12.8453C16.4911 12.5328 16.6667 12.1089 16.6667 11.6668V3.3335M10 13.3335V16.6668M7.5 16.6668H12.5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" />
            <path d="M6.66699 10.0003L9.16699 7.50033L10.8337 9.16699L13.3337 6.66699" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
          <span class="font-normal">{@current_position + 1}/ {@total_slides}</span>
        </div>
      </div>
      <div class="flex-1 flex items-center justify-center gap-x-4 px-4 py-2 overflow-hidden">
        <div class="flex-shrink-0">
          <button
            :if={@current_position > 0}
            phx-click="current-page"
            phx-value-page={@current_position - 1}
            class="btn btn-circle bg-primary-50 border-none hover:bg-primary-100"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 rotate-180" viewBox="0 0 16 16" fill="none">
              <path d="M-0.000155798 8.91984L-0.000155623 6.91984L11.9998 6.91984L6.49984 1.41984L7.91985 -0.000157095L15.8398 7.91984L7.91984 15.8398L6.49984 14.4198L11.9998 8.91984L-0.000155798 8.91984Z" fill="currentColor" />
            </svg>
          </button>
          <div
            :if={@current_position <= 0}
            class="btn btn-circle bg-gray-100 border-none opacity-50 cursor-not-allowed"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400 rotate-180" viewBox="0 0 16 16" fill="none">
              <path d="M-0.000155798 8.91984L-0.000155623 6.91984L11.9998 6.91984L6.49984 1.41984L7.91985 -0.000157095L15.8398 7.91984L7.91984 15.8398L6.49984 14.4198L11.9998 8.91984L-0.000155798 8.91984Z" fill="currentColor" />
            </svg>
          </div>
        </div>

        <div class="h-full aspect-video bg-white rounded-lg border border-gray-200 overflow-hidden">
          <img
            :if={@current_slide_url}
            src={@current_slide_url}
            class="w-full h-full object-contain"
            alt={"Slide #{@current_position + 1}"}
          />
          <div
            :if={!@current_slide_url}
            class="w-full h-full flex items-center justify-center text-gray-400"
          >
            <span>{gettext("No slide available")}</span>
          </div>
        </div>

        <div class="flex-shrink-0">
          <button
            :if={@current_position < @total_slides - 1}
            phx-click="current-page"
            phx-value-page={@current_position + 1}
            class="btn btn-circle bg-primary-50 border-none hover:bg-primary-100"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 16 16" fill="none">
              <path d="M-0.000155798 8.91984L-0.000155623 6.91984L11.9998 6.91984L6.49984 1.41984L7.91985 -0.000157095L15.8398 7.91984L7.91984 15.8398L6.49984 14.4198L11.9998 8.91984L-0.000155798 8.91984Z" fill="currentColor" />
            </svg>
          </button>
          <div
            :if={@current_position >= @total_slides - 1}
            class="btn btn-circle bg-gray-100 border-none opacity-50 cursor-not-allowed"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400" viewBox="0 0 16 16" fill="none">
              <path d="M-0.000155798 8.91984L-0.000155623 6.91984L11.9998 6.91984L6.49984 1.41984L7.91985 -0.000157095L15.8398 7.91984L7.91984 15.8398L6.49984 14.4198L11.9998 8.91984L-0.000155798 8.91984Z" fill="currentColor" />
            </svg>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
