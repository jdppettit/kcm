# kcm

kcm, or kubectl configuration manager, is a simple command line application to manage your kubectl config entries.

## Build

While this project does include a binary file you are welcome to try, you are likely to have more luck compiling it yourself. To do this you will need:

* erlang
* elixir

If you have Erlang and Elixir working on your machine, you can then:

1. Clone this repository
2. `mix deps.get`
3. `mix escript.build`
4. Take the resulting `kcm` binary file and add it to your preferred path included directory

## Usage

You will then want to add all the kubectl config files you want to manage to `~/.kube`, I use `config.<name>` but you can use any naming scheme.

Next add your config files to kcm using the `create` command:

```
kcm create name_of_config /path/to/config
```

Repeat this for each config file you want to manage using kcm.

Confirm all is well by running `list`:

```
$ kcm list
Example1 /home/example/.kube/config.example1
Example2 /home/example/.kube.config.example2
```

To activate a configuration simply run `activate`:

```
$ kcm activate Example1
```

If you execute `kubectl` you should now be using the correct config context. Additionally you can config by running `ls -lah` on your `.kube` directory to see the active symbolic link.

## Considerations

When you use kcm for the first time kcm will rename your existing `config` file to `config.kcm_backup` for safe keeping. 

kcm uses symbolic links for activating and managing your configuration files afterwords. If you want to stop using kcm you can simply move `config.kcm_backup` back to `config` and remove the kcm binary.

While this was designed to minimize risk of losing your configs, please note **this project is in active development, so if you have configs that are vital, back them up!** 

## Commands

### `list`

View all managed configurations.

```
$ kcm list
Example1 /home/example/.kube/config.example1
Example2 /home/example/.kube.config.example2
```

`list` will report which configuration is active, if any are currently active using `[*]` next to the appropriate config:

```
$ kcm list
Example1 - /home/example/.kube/config.example1 [*]
Example2 - /home/example/.kube.config.example2
```

### `create`

Add a config file to kcm to be managed.

```
$ kcm create example1 /path/to/example1
```

### `status`

View the currently active config.

```
$ kcm status
Example1 - /path/to/example1
```

### `remove`

Remove a config from kcm management.

```
$ kcm remove example1
```

Note: This does not impact the actual configuration file at all, just whether or not kcm knows about it.

## Configuration

All of the information used by kcm is stored in a JSON file in `~/.kcm/config.json`.

If you prefer, you can modify this file directly to add your configs. The expected format is:

```
{
  configs: [
    {
      name: "name",
      path: "/path/to/name"
    }
  ]
}
```

## Development

If you want to hack on kcm you can do so using the same pattern mentioned in the build section. Make the changes you want to make, then rebuild using `mix escript.build` and use the newly built binary to test.




