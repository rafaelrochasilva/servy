defmodule Servy.Fetcher do
  @moduledoc """
  Fetcher is used to make async calls to VideoFetcher 
  """

  def async(fun) do
    caller = self()

    spawn(fn -> send(caller, {:result, fun.()}) end)
  end

  def get_result do
    receive do {:result, filename} -> filename end
  end
end
