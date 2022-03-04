NAME
====



`Log::Dispatch::Msg` - log message class

DESCRIPTION
===========



This class represents a data structure holding information about a log entry.

ATTRIBUTES
==========



### [`Instant`](https://docs.raku.org/type/Instant)`:D $.timestamp`

The moment when message object has been produced

### `LOG-LEVEL:D $.level`

Message level provided with [`Log::Dispatch::Source`](Source.md) `log` method call. Defaults to `INFO`.

### `Str $.source`

If defined then hold the source name, as in [`Log::Dispatch::Source`](Source.md) `$.LSN` attribute.

### `Mu @.msg`

The log message, as provided with [`Log::Dispatch::Source`](Source.md) `log` method call. The list is maintained unmodified, i.e. it represents the positional arguments of the call. For example, a call like:

```raku
my $obj = Foo.new;
self.log: "Count: ", 42, " for object ", $obj, :debug;
```

would result in:

    ["Count: ", 42, " for object ", <instance of Foo>]

METHODS
=======



### `method fmt-level()`

Returns a formatted representation of message level which is just the level name left-padded with spaces to match the longest level name length of 9 symbols.

### `method fmt-timestamp()`

Returns formatted timestamp in form of a string *YYYY-MM-DD HH:MM::SS*.

### `method fmt-lines(--` Seq:D)>

Returns a sequence of lines representing the message object in the default log format which consists of:

    <date-time> [<padded level>] [<source name if present>] <a message line>

Date-time and level strings produced by `fmt-timestamp` and `fmt-level` methods correspondingly.

Message lines are produced by:

  * invoking `gist` method on each element of `@.msg` list

  * joining the resulting strings and then splitting them by new-lines

  * prefixing each resulting single line with date-time, level, and source name strings

In other words, if the log message consisted of something like:

    "Line 1\n", 42, "\nLine 3"

The the method would produce a sequence of three lines:

    1970-01-31 01:02:03 [     INFO] Line 1
    1970-01-31 01:02:03 [     INFO] 42
    1970-01-31 01:02:03 [     INFO] Line 3

So, if one has a multi-line output to be logged they must not be worried about it and can just submit it into the dispatcher as-is.

SEE ALSO
========

[`Log::Dispatch`](../Dispatch.md), [`Log::Dispatch::Source`](Source.md), [`Log::Dispatch::Destination`](Destination.md)

AUTHOR
======

Vadim Belman <vrurg@cpan.org>

