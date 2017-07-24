# ecg

Generate a GraphViz `.dot` file describing a module call graph.

![Erlang lists module call graph](examples/lists-2inches.png)

## Build

```sh
rebar3 escriptize
```

## Usage

```sh
bin/ecg lists /Users/erszcz/apps/erlang/20.0/lib/erlang/lib/stdlib-3.4.1/ebin/lists.beam
open lists.png      # on macOS
xdg-open lists.png  # on Linux
```

```sh
bin/ecg dtls /Users/erszcz/src/erlang/otp/lib/ssl/ebin/dtls_udp_listener.beam \
             /Users/erszcz/src/erlang/otp/lib/ssl/ebin/dtls_connection.beam
cat dtls.dot
open dtls.png       # on macOS
xdg-open dtls.png   # on Linux
```

## Similar tools

-   [Recon's app\_deps.erl][app_deps] is the thing if you're looking into
    visualizing relations between Erlang applications. Good stuff!

-   [Grapherl][grapherl] will show you dependencies between modules. Very nice!

-   For visualizing FSM states you might try these remnants of the past
    (YMMV, don't complain I didn't warn you):

    * https://github.com/erszcz/graph_draw - not authored by me,
      just scavenged off the internet and archived here on GitHub

    * http://erlang.org/pipermail/erlang-questions/2001-October/003717.html

[app_deps]: https://github.com/ferd/recon/blob/e3e2db564a4a176f0a733161b39bf0f0bd4ed3a8/script/app_deps.erl
[grapherl]: https://github.com/eproxus/grapherl
