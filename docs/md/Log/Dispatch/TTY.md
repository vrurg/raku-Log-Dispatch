NAME
====



`Log::Dispatch::TTY` - console destination with color support

DESCRIPTION
===========



This log destination sends lines of log onto the console. If the console is a TTY (i.e. not a redirection into a file or a pipe) then the lines of output are colored according to message levels.

ATTRIBUTES
==========



### `Bool:D $.color`

If *True* (which is the default) then the output would be colored. But only if the console is a TTY.

### `IO::Handle $.tty`

If set then it must be an opened file handle.

METHODS
=======



### `submethod TWEAK(Bool:D :$console)`

If an instance of this class is created with `:console` named argument passed into the constructor then any output file handle is considered a TTY and the output will be colored if `$.color` flag is set:

```raku
    my $logger = Log::Dispatch.new;
    $logger.add: 'TTY', :console, :color; # Always use ANSI colors
```

SEE ALSO
========

[`Log::Dispatch`](../Dispatch.md), [`Log::Dispatch::Source`](Source.md), [`Log::Dispatch::Destination`](Destination.md), [`Log::Dispatch::Msg`](Msg.md)

AUTHOR
======

Vadim Belman <vrurg@cpan.org>

