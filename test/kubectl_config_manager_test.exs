defmodule KubectlConfigManagerTest do
  use ExUnit.Case
  doctest KubectlConfigManager

  test "greets the world" do
    assert KubectlConfigManager.hello() == :world
  end
end
