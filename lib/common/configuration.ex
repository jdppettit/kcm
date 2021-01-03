defmodule KubernetesConfigManager.Configuration do
  alias KubernetesConfigManager.Format

  @config_directory Application.get_env(:kcm, :config_directory, "#{Path.expand("~/.kcm")}")
  @config_path "#{@config_directory}/config.json"
  @default_config """
    {
      "configs": []
    }
  """

  def config_directory_present? do
    File.exists?(@config_directory)
  end

  def create_config_file_if_needed do
    case File.exists?(@config_path) do
      false ->
        File.touch(@config_path)
        File.write(@config_path, @default_config)
        :ok

      _ ->
        :ok
    end
  end

  def create_config_directory! do
    File.mkdir!(@config_directory)
  end

  def read_configuration do
    {:ok, json} = File.read(@config_path)
    json |> Jason.decode!()
  end

  def ready? do
    if not config_directory_present?() do
      create_config_directory!()
    else
      create_config_file_if_needed()
    end

    :ok
  end

  def add_config(name, path) do
    existing = read_configuration()

    updated =
      Map.put(existing, "configs", [
        %{name: name, path: path, active: false} | existing["configs"]
      ])

    write_config(updated)
  end

  def remove_config(name) do
    existing = read_configuration()

    updated_configs =
      existing["configs"]
      |> Enum.filter(fn c ->
        c["name"] != name
      end)

    updated = Map.put(existing, "configs", updated_configs)
    write_config(updated)
  end

  def write_config(config) do
    {:ok, config} = Jason.encode(config)
    File.write(@config_path, config)
    :ok
  end

  def prepare do
    :ok = ready?()
    read_configuration
  end

  def is_managed?() do
    case File.read_link(Path.expand("~/.kube/config")) do
      {:ok, _target} ->
        true

      {:error, _failure} ->
        false
    end
  end

  def get_active() do
    if not is_managed?() do
      %{name: nil, path: nil}
    else
      {:ok, target} = File.read_link(Path.expand("~/.kube/config"))
      target
    end
  end

  def print_active() do
    active_path = get_active()
    active_config = read_configuration()

    active_entry = get_config_entry_by_path(active_config, active_path)

    IO.puts("Currently active configuration")

    IO.puts(Format.config_entry(active_entry))
  end

  def clean_existing_config() do
    if is_managed?() do
      File.rm(Path.expand("~/.kube/config"))
    else
      if File.exists?(Path.expand("~/.kube/config")) do
        File.rename(
          Path.expand("~/.kube/config"),
          Path.expand("~/.kube/config.kcm_backup")
        )
      end
    end

    :ok
  end

  def get_config_entry_by_path(configs, path_to_find) do
    configs["configs"]
    |> Enum.map(fn c ->
      if c["path"] == path_to_find do
        c
      else
        nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
    |> (fn config -> Enum.at(config, 0) end).()
  end

  def get_config_entry_by_name(configs, name_to_find) do
    configs["configs"]
    |> Enum.map(fn c ->
      if c["name"] == name_to_find do
        c
      else
        nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
    |> (fn config -> Enum.at(config, 0) end).()
  end

  def make_config_active(name) do
    existing = read_configuration()
    config_entry = get_config_entry_by_name(existing, name)
    File.ln_s!(config_entry["path"], Path.expand("~/.kube/config"))
    :ok
  end
end
