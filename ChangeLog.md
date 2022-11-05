CHANGELOG
=========



head
====

v0.0.8

  * Added `attached` method to `Log::Dispatch::Source`

v0.0.5
------

  * Respect timezones, make `$.timestamp` of `Log::Dispatch::Msg` a [`DateTime`](https://docs.raku.org/type/DateTime) instance

v0.0.4
------

  * Include thread ID into log if requested

  * Fix a potential race

v0.0.3
------

  * Renamed `$.name` to `$.LSN` in `Log::Dispatch::Source`

v0.0.2
------

  * Fixed an extra whitespace in multi-line messages sent to `File` destination

v0.0.1
------

  * Initial release

