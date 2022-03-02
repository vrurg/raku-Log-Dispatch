use v6.d;
unit class Log::Dispatch::TTY;
use Log::Dispatch::Destination;
use Log::Dispatch::Msg;
use Terminal::ANSI::OO 'ansi';

also does Log::Dispatch::Destination;

has Bool $!console is built;
has Bool:D $.color = True;
has IO::Handle $.tty;

constant %L2C =
    DEBUG => ansi.yellow,
    INFO => '',
    NOTICE => ansi.yellow,
    WARNING => ansi.bright-magenta,
    ERROR => ansi.red,
    CRITICAL => ansi.red,
    ALERT => ansi.bg-red ~ ansi.black,
    EMERGENCY => ansi.bg-red ~ ansi.black;

submethod TWEAK {
    $!console //= ($!tty // $*OUT).t;
}

method report(Log::Dispatch::Msg:D $msg) {
    my $pfx = "";
    my $sfx = "";
    if $!console && $!color {
        with $msg.level.key {
            $pfx = %L2C{$_};
            $sfx = ansi.text-reset;
        }
    }
    ($.tty // $*OUT).say: $pfx ~ $msg.fmt-lines.join("\n") ~ $sfx;
}