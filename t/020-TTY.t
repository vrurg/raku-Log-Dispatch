use Test;
use Test::Output;
use Log::Dispatch;
use Log::Dispatch::Source;
use Log::Dispatch::TTY;
use Terminal::ANSI::OO 'ansi';

plan 1;

my class LogSrc does Log::Dispatch::Source { }

my $logger = Log::Dispatch.new;
my $inst = LogSrc.new;

$logger.add: 'TTY', :console;
$logger.add: $inst;

my regex date-time { \d**4 '-' \d**2 '-' \d**2 ' ' \d**2 ':' \d**2 ':' \d**2 };

my $alert-esc = %Log::Dispatch::TTY::L2C<ALERT>;
my $reset-esc = ansi.text-reset;
output-like
    { $inst.log: "Oopsish-oops!", :alert },
    /^ $alert-esc <date-time> \s '[    ALERT] Oopsish-oops!' $reset-esc \n $/,
    "an alert message";

done-testing;
