# ecg

Generate a GraphViz `.dot` file describing a module call graph.

![Erlang lists module call graph](examples/lists-2inches.png)

## Build

```sh
rebar3 escriptize
```

## Usage

```sh
bin/ecg lists
open lists.png      # on macOS
xdg-open lists.png  # on Linux
```
