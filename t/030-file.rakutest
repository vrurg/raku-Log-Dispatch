use Test;
use Log::Dispatch;
use Log::Dispatch::Source;
use Log::Dispatch::File;

plan 1;

my $tmp-log = $*TMPDIR.add( 'log-dispatch-' ~ $*PID ~ "-" ~ rand );

my regex date-time { \d**4 '-' \d**2 '-' \d**2 ' ' \d**2 ':' \d**2 ':' \d**2 };

my class LogSrc does Log::Dispatch::Source {
    method log-source-name { "FileTest" }
}

my $logger = Log::Dispatch.new;
my $inst = LogSrc.new;

$logger.add: 'File', :file($tmp-log);
$logger.add: $inst;

$inst.log: "Line 1";
$inst.log: "Line 2", :warning;

$logger.shutdown;

like
    $tmp-log.slurp,
    /^^ <date-time> ' [     INFO] [FileTest] Line 1' \n <date-time> ' [  WARNING] [FileTest] Line 2' \n $/,
    "log content";

unlink $tmp-log;

done-testing;
