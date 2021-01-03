defmodule KubernetesConfigManager do
  use ExCLI.DSL, escript: true

  alias KubernetesConfigManager.{Configuration, Format}

  name("kcm")
  description("Simply manage all your kubectl config files")

  command :list do
    description("View list of available configurations")

    run _context do
      config = Configuration.prepare()
      Format.config_list(config["configs"])
    end
  end

  command :status do
    description("Get current kcm status")

    run _context do
      Configuration.print_active()
    end
  end

  command :create do
    description("Add new configuration")

    argument(:name)
    argument(:path)

    run context do
      name = context[:name]
      path = context[:path]
      :ok = Configuration.add_config(name, path)
    end
  end

  command :remove do
    description("Remove a configuration")

    argument(:name)

    run context do
      name = context[:name]
      :ok = Configuration.remove_config(name)
    end
  end

  command :activate do
    description("Activate a kubectl configuration")

    argument(:name)

    run context do
      name = context[:name]

      :ok = Configuration.clean_existing_config()
      :ok = Configuration.make_config_active(name)
    end
  end
end
