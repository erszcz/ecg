# ecg

Generate a GraphViz `.dot` file describing a module call graph.

## Build

```sh
rebar3 escriptize
```

## Usage

```sh
_build/default/bin/ecg lists | grep -v '^lists:' | dot -Tpng > lists.png
open lists.png      # on macOS
xdg-open lists.png  # on Linux
```
