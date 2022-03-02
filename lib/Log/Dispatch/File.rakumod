use v6.d;
unit class Log::Dispatch::File;
use Log::Dispatch::Destination;
use Log::Dispatch::Msg;
use Log::Dispatch::X;

also does Log::Dispatch::Destination;

has IO:D() $.file is required;
has Bool:D $.safe = False;
has Bool:D $.discrete = False;
has IO::Handle $!log-h;
has Lock:D $!lh-lock .= new;

submethod TWEAK {
    $!log-h = self!get-fh unless $!discrete;
}

method !get-fh {
    $!file.open(:a, |($!safe ?? :out-buffer(0) !! Empty))
}

method report(Log::Dispatch::Msg:D $message) {
    $!lh-lock.protect: {
        if $!discrete {
            with self!get-fh {
                .print: $message.fmt-lines.map({ $_ ~ "\n" });
                .close;
            }
        }
        else {
            Log::Dispatch::X::LogClosed.new(processor => self).throw unless $!log-h;
            $!log-h.print: $message.fmt-lines.map({ $_ ~ "\n" });
        }
    }
}

method close {
    $!lh-lock.protect: {
        $!log-h.close if $!log-h;
        $!log-h = Nil;
    }
}

method on-quit($) { self.close }
method on-last { self.close }