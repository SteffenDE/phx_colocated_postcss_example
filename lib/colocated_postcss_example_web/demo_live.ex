defmodule ColocatedPostcssExampleWeb.DemoLive do
  use ColocatedPostcssExampleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <style>
      * {
        background: none;
      }
    </style>
    <.global_colocated_css />
    <p data-test="global" class="test-global-css">Should have red background</p>
    <.scoped_colocated_css />
    <p data-test="scoped" class="test-scoped-css">Should have no background (out of scope)</p>
    """
  end

  defp global_colocated_css(assigns) do
    ~H"""
    <style :type={ColocatedPostcssExampleWeb.GlobalCSS}>
      .test-global-css { background-color: rgb(255, 0, 0); }
    </style>
    """
  end

  defp scoped_colocated_css(assigns) do
    ~H"""
    <style :type={ColocatedPostcssExampleWeb.ColocatedCSS}>
      .test-scoped-css { background-color: rgb(0, 0, 255); }
    </style>
    <div>
      <span data-test-scoped="blue" class="test-scoped-css">Should have blue background</span>
      <.scoped_css_inner_block_one>
        <span data-test-scoped="blue" class="test-scoped-css">
          Should have blue background
        </span>
      </.scoped_css_inner_block_one>
      <.scoped_css_inner_block_one>
        <span data-test-scoped="blue" class="test-scoped-css">
          Should have blue background
        </span>
      </.scoped_css_inner_block_one>
      <.scoped_css_inner_block_two>
        <span data-test-scoped="blue" class="test-scoped-css">
          Should have blue background
        </span>
      </.scoped_css_inner_block_two>
      <.scoped_css_slot_one>
        <:test>
          <span data-test-scoped="blue" class="test-scoped-css">
            Should have blue background
          </span>
        </:test>
      </.scoped_css_slot_one>
      <.scoped_css_slot_two>
        <:test>
          <span data-test-scoped="blue" class="test-scoped-css">
            Should have blue background
          </span>
        </:test>
      </.scoped_css_slot_two>
    </div>
    """
  end

  slot :inner_block, required: true

  defp scoped_css_inner_block_one(assigns) do
    ~H"""
    {render_slot(@inner_block)}
    """
  end

  slot :inner_block, required: true

  defp scoped_css_inner_block_two(assigns) do
    ~H"""
    <style :type={ColocatedPostcssExampleWeb.ColocatedCSS}>
      .test-scoped-css { background-color: rgb(255, 255, 0); }
    </style>
    <div>
      <span data-test-scoped="yellow" class="test-scoped-css">Should have yellow background</span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  slot :test, required: true

  defp scoped_css_slot_one(assigns) do
    ~H"""
    {render_slot(@test)}
    """
  end

  slot :test, required: true

  defp scoped_css_slot_two(assigns) do
    ~H"""
    <style :type={ColocatedPostcssExampleWeb.ColocatedCSS}>
      .test-scoped-css { background-color: rgb(0, 255, 0); }
    </style>
    <div>
      <span data-test-scoped="green" class="test-scoped-css">Should have green background</span>
      {render_slot(@test)}
    </div>
    """
  end
end
