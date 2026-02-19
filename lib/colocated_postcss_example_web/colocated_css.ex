defmodule ColocatedPostcssExampleWeb.ColocatedCSS do
  use Phoenix.LiveView.ColocatedCSS

  @impl true
  def transform("style", attrs, css, meta) do
    {css, directives} = do_scope(css, attrs, meta)
    {:ok, css, directives}
  end

  defp do_scope(css, _opts, meta) do
    scope = hash("#{meta.module}_#{meta.line}: #{css}")
    css = "@phx-scoped [phx-css-#{scope}] { #{css} }"

    {css, [tag_attribute: {"phx-css-#{scope}", true}]}
  end

  defp hash(string) do
    # It is important that we do not pad
    # the Base32 encoded value as we use it in
    # an HTML attribute name and = (the padding character)
    # is not valid.
    string
    |> then(&:crypto.hash(:md5, &1))
    |> Base.encode32(case: :lower, padding: false)
  end
end

defmodule ColocatedPostcssExampleWeb.GlobalCSS do
  use Phoenix.LiveView.ColocatedCSS

  @impl true
  def transform("style", _attrs, css, _meta) do
    {:ok, css, []}
  end
end
