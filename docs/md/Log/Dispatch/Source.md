NAME
====



`Log::Dispatch::Source` - role providing logging source interface

DESCRIPTION
===========



This role implements all basic functionality necessary to provide a source of log messages.

Consumes `Log::Dispatch::Processor`.

ATTRIBUTES
==========



### `Str $.name`

If set provides source name. In a log file line it would be represented in square brackets sitting next to the message level. Something like:

    1970-01-31 01:02:03 [    ALERT] [MySource] Ouch!

METHODS
=======



### `method log(+@msg, *%level)`

Dispatch a new log message. The method creates a new [`Log::Dispatch::Msg`](Msg.md) object and submits it into the dispatcher. For exmaple:

```raku
class MyApp does Log::Dispatch::Source {
    method some-action {
        my $success;
        ...
        if $success {
            self.log: "The action succeeded";
        }
        else {
            self.log: "Too bad! Something went wrong", :critical;
        }
    }
}
```

Note that multiple level named arguments can be used, but the method would throw for any unknown one and will chose the one with the most critical level among the valid ones. I.e., would it happen so that both `:critical` and `:debug` are nameds are used then `:critical` would win the duel.

### `method log-source-name()`

This method is to be defined by the consuming class if it wants to define the source name. To get a log line looking like in the example for attribute `$.name` one has to have this method as:

```raku
method log-source-name { "MySource" }
```

### `method attach(--` Promise:D)>

Must never be used and better be not overriden without a **really** good reaon.

SEE ALSO
========

[`Log::Dispatch`](../Dispatch.md), [`Log::Dispatch::Destination`](Destination.md), [`Log::Dispatch::Msg`](Msg.md)

AUTHOR
======

Vadim Belman <vrurg@cpan.org>

