defmodule Servy.BearController do
  alias Servy.Conv

  def index(conv) do
    "Yogi, Panda, Paddington"
  end

  def show(conv, id) do
    %Conv{ conv | status: 200, resp_body: "Bear #{id}"}
  end

  def create(conv) do
    %Conv{conv | status: 201,
      resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"}
  end

  def delete(conv) do
    %{conv | status: 403, resp_body: "You can't delete my bears!"}
  end
end