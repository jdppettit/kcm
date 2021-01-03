defmodule KubernetesConfigManagerTest do
  use ExUnit.Case
  doctest KubernetesConfigManager

  test "greets the world" do
    assert KubernetesConfigManager.hello() == :world
  end
end
