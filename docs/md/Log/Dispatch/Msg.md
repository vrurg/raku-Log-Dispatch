NAME
====



`Log::Dispatch::Msg` - log message class

DESCRIPTION
===========



This class represents a data structure holding information about a log entry.

ATTRIBUTES
==========



### [`DateTime:D`](https://docs.raku.org/type/DateTime)`:D $.timestamp`

The moment when message object has been produced

### `LOG-LEVEL:D $.level`

Message level provided with [`Log::Dispatch::Source`](Source.md) `log` method call. Defaults to `INFO`.

### `Str $.source`

If defined then holds the source name, as in [`Log::Dispatch::Source`](Source.md) `$.LSN` attribute.

### `Str:D $.msg`

The log message, as provided with [`Log::Dispatch::Source`](Source.md) `log` method call. All positional arguments, passed into the method, will be `gist`-ed and then joined into a single string. Any newlines in the message are preserved, so the message is always a single unsplit string object.

### `Int $.thread-id`

ID of the thread where the message has been produced. Can be undefined if the source did not request this feature.

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

  * splitting the `$.msg` attribute by new-lines

  * prefixing each resulting single line with date-time, level, and source name strings

In other words, for a message line like this:

    "Line 1\n42\nLine 3"

the method would produce a sequence of three lines:

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

