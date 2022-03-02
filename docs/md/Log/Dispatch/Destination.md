NAME
====



`Log::Dispatch::Destination` - role implementing destination end-point interface

DESCRIPTION
===========



This role must be consumed by any class, implementing log destination.

Consumes `Log::Dispatch::Processor`

ATTRIBUTES
==========



### `LOG-LEVEL:D $.max-level`

Defines the maximum log level this destination would record. Any message with a level higher than this gets dropped.

**Default:** `LOG-LEVEL::INFO`

METHODS
=======



### `method report(`[`Log::Dispatch::Msg`](Msg.md)`:D $msg)`

The only method to be implemented by a destination end-point class. Must take the `$msg` object and translate it into a format, acceptable by the destination. Normally it would be as simple, as producing one or few lines using the helper method `fmt-lines`, provided by [`Log::Dispatch::Msg`](Msg.md) class. But a destination more complicated may require more complicated data structure to be submitted.

### `method attach($dispatcher)`

Don't override unless there is a **really** good reason.

SEE ALSO
========

[`Log::Dispatch`](../Dispatch.md), [`Log::Dispatch::Source`](Source.md), [`Log::Dispatch::Msg`](Msg.md)

AUTHOR
======

Vadim Belman <vrurg@cpan.org>

