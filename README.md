NAME
====



`Log::Dispatch` - Dispatching multi-source, multi-destination logging

DESCRIPTION
===========



This module provide a means to have multiple log destinations withing single application with extra hassle but with easy support for concurrency.

Model
-----

The model this module is based upon is built around a single dispatcher, which can be considered as a minimalistic wrapper around a [`Supplier`](https://docs.raku.org/type/Supplier). The dispatcher accepts message objects from sources and dispatches them into destinations.

A source here is any instance of a class consuming [`Log::Dispatch::Source`](Dispatch/Source.md) role.

A destination is an instance of a class consuming [`Log::Dispatch::Destination`](Dispatch/Destination.md) role. It represented an endpoint where messages are to be submitted to.

For example, one may have an application and wants to log its messages into a file and on the console. This is as simple as adding `does Log::Dispatch::Source` to the declaration of our application class. And by having something like the following example anywhere in application code:

    my $logger = Log::Dispatch.new;
    $logger.add: 'File', :max-level(LOG-LEVEL::DEBUG), $log-file-name;
    $logger.add: Log::Dispatch::TTY;

Note that the application would then log all messages into a log file, but only the essential ones to the console.

It worth to mention that each destination code is by default gets its own thread. For a source it is normally sufficient just to use `log` method provided by [`Log::Dispatch::Source`](Dispatch/Source.md) role.

Processors
----------

A *processor* is an end-point attached to the dispatcher. The module provides two kinds of processors: source and destination implemented, correspondingly, by [`Log::Dispatch::Source`](Dispatch/Source.md) and [`Log::Dispatch::Destination`](Dispatch/Destination.md) roles.

`Log::Dispatch::Processor` role is just an interface requiring `attach` method to be implemented.

Destinations
------------

Currently the module only provides two destination end-points: [`Log::Dispatch::TTY`](Dispatch/TTY.md) and [`Log::Dispatch::File`](Dispatch/File.md). Syslog support may be added later.

Performance
-----------

The multi-destination concept with per-destination maximum log-level support implies that there is no way to optimize away some possibly unused calls to the method `log` because any message, no matter what log-level it is assigned with, must be accepted and emitted into dispatcher's [`Supply`](https://docs.raku.org/type/Supply).

Log Levels
----------

The number and names of log levels are taken from *syslog* standard exactly for the reason it is the most common logging standard existing around.

Levels are provided as `LOG-LEVEL` enum values declared by [`Log::Dispatch::Types`](Dispatch/Types.md) module. Here is the list in the ascending order:

  * `EMERGENCY`, which is *0*

  * `ALERT`

  * `CRITICAL`

  * `ERROR`

  * `WARNING`

  * `NOTICE`

  * `INFO` – the per-destination default

  * `DEBUG`

Non-polluting
-------------

This module tries to reduce namespace pollution to the absolute minimum. The only symbol exported is `LOG-LEVEL` enumeration type for comparatively simple registration of a destination, as in the above example from the [Model](#Model) section.

METHODS
=======



### `multi method add(Log::Dispatch::Processor:D $processor --` Nil)>

Adds an end-point object `$processor` to the dispatcher.

Note that the `attach` method of a custom processor is expected to return a [`Promise`](https://docs.raku.org/type/Promise) which is to be kept only and only when the processor is ready. The meaning of being ready would then depend on the end-point type only.

### `multi method add(Log::Dispatch::Processor:U $processor, *%params)`

This method creates an instance of the `$processor` type using `%params` as constructor parameters. The resulting instance is then gets registered with the dispatcher.

### `multi method add(`[`Str`](https://docs.raku.org/type/Str)`:D $processor, *%params)`

This method determines processor type based on the name provided in `$processor` parameter and then instantiates it as described for the previous method candidate.

The following rules are used to resolve the type:

  * if it contains a colon pair *::* then the name is used as-is

  * otherwise the name is prefixed with *Log::Dispatch::* prefix

  * the resulting name is used to load a module of the same name with `require`

See the example in the [Model](#Model) section above.

### `shutdown`

Can only be issued once on a dispatcher. Any subsequent call to the method is ignored.

Closes the dispatching supply by invoking method `done` on the [`Supplier`](https://docs.raku.org/type/Supplier).

The method can be invoked manually when absolutely necessary. But normally is it called inside an `END` phaser to ensure that the logging capabilities are available up until the complete stop of the application.

### `Supply`

Produces a new supply to be tapped upon

### `dispatch-msg(`[`Log::Dispatch::Msg`](Dispatch/Msg.md)`:D $msg)`

Emits [`Log::Dispatch::Msg`](Dispatch/Msg.md) object into the dispatching supply.

SEE ALSO
========

[`Log::Dispatch::File`](Dispatch/File.md), [`Log::Dispatch::TTY`](Dispatch/TTY.md), [`Log::Dispatch::Types`](Dispatch/Types.md), [`Log::Dispatch::Source`](Dispatch/Source.md), [`Log::Dispatch::Destination`](Dispatch/Destination.md), [`Log::Dispatch::Msg`](Dispatch/Msg.md)

AUTHOR
======

Vadim Belman <vrurg@cpan.org>

LICENSE
=======



Atristic 2.0

