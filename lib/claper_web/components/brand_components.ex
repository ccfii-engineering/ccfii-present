defmodule ClaperWeb.BrandComponents do
  @moduledoc "Reusable CCFII Present branding components."

  use Phoenix.Component
  use Gettext, backend: ClaperWeb.Gettext

  attr :variant, :atom, values: [:full, :mark], default: :full
  attr :class, :any, default: nil

  @doc "Renders the CCFII Present logo or compact mark."
  def logo(assigns) do
    assigns = assign(assigns, :src, logo_src(assigns.variant))

    ~H"""
    <img src={@src} alt={gettext("CCFII Present")} class={@class} />
    """
  end

  attr :class, :any, default: nil

  @doc "Renders a safe attribution link to the upstream Claper project."
  def attribution(assigns) do
    ~H"""
    <a
      href="https://github.com/ClaperCo/Claper"
      target="_blank"
      rel="noopener noreferrer"
      class={@class}
    >
      {gettext("Powered by Claper")}
    </a>
    """
  end

  defp logo_src(:full), do: "/images/ccfii-present-logo.png"
  defp logo_src(:mark), do: "/images/ccfii-present-mark.png"
end
