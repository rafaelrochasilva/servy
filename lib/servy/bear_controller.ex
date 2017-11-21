defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  def index(conv) do
    list = Wildthings.list_bears
           |> Enum.filter(&Bear.is_grizzly/1)
           |> Enum.sort(&Bear.sort_asc_by_name/2)
           |> Enum.map(&bear_item/1)
           |> Enum.join

    %Conv{ conv | status: 200, resp_body: "<ul>#{list}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.find_bear(id)
    %Conv{ conv | status: 200, resp_body: "<h1>#{bear.name} #{bear.id}: #{bear.type}</h1>"}
  end

  def create(conv) do
    %Conv{conv | status: 201,
      resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"}
  end

  def delete(conv) do
    %{conv | status: 403, resp_body: "You can't delete my bears!"}
  end

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
