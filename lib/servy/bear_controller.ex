defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../templates", __DIR__)

  def index(conv) do
    bears =
      Wildthings.list_bears
      |> Enum.sort(&Bear.sort_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.find_bear(id)
    render(conv, "show.eex", bear: bear)
  end

  def create(conv) do
    %Conv{conv | status: 201,
      resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"}
  end

  def delete(conv) do
    %{conv | status: 403, resp_body: "You can't delete my bears!"}
  end

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %Conv{ conv | status: 200, resp_body: content}
  end
end
