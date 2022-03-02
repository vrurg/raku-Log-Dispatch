use v6.d;
unit role Log::Dispatch::Destination;
use Log::Dispatch;
use Log::Dispatch::Processor;
use Log::Dispatch::Msg;
use Log::Dispatch::Types;

also does Log::Dispatch::Processor;

method report(Log::Dispatch::Msg:D) {...}

has LOG-LEVEL:D $.max-level = INFO;

method attach($dispatcher) {
    my $ready = Promise.new;
    start react {
        whenever $dispatcher -> $message {
            self.report: $message if $message.level <= $.max-level;
            QUIT {
                self.?on-quit: $_;
            }
            LAST {
                self.?on-last;
            }
            CATCH {
                default {
                    note "===REPORTER FAILURE=== " ~ .message ~ "\n" ~ .backtrace;
                    .rethrow
                }
            }
        }
        $ready.keep;
    }
    $ready;
}