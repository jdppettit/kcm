defmodule KubectlConfigManager.Format do
  alias KubectlConfigManager.Configuration

  def format_list(list) do
    list
    |> Enum.map(fn c ->
      config_entry(c)
    end)
  end

  def config_entry(entry) do
    if Configuration.get_active() == entry["path"] do
      "#{entry["name"]} - #{entry["path"]} [*]"
    else
      "#{entry["name"]} - #{entry["path"]}"
    end
  end

  def config_list(list) do
    list
    |> format_list
    |> Enum.map(fn c ->
      IO.puts(c)
    end)
  end
end
