defmodule ClaperWeb.BrandComponentsTest do
  use ClaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias ClaperWeb.BrandComponents

  test "renders the accessible full lockup" do
    html = render_component(&BrandComponents.logo/1, %{variant: :full, class: "h-10"})
    assert html =~ ~s(src="/images/ccfii-present-logo.png")
    assert html =~ ~s(alt="CCFII Present")
    assert html =~ ~s(class="h-10")
  end

  test "renders the compact mark" do
    html = render_component(&BrandComponents.logo/1, %{variant: :mark})
    assert html =~ ~s(src="/images/ccfii-present-mark.png")
  end

  test "renders safe upstream attribution" do
    html = render_component(&BrandComponents.attribution/1, %{})
    assert html =~ "Powered by Claper"
    assert html =~ ~s(href="https://github.com/ClaperCo/Claper")
    assert html =~ ~s(target="_blank")
    assert html =~ ~s(rel="noopener noreferrer")
  end
end
