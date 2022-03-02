use v6.d;
use Log::Dispatch::Msg;
use Log::Dispatch::Processor;
use Log::Dispatch::Types;

my @dispatchers;
my Lock:D $reg-lock .= new;

class Log::Dispatch:ver($?DISTRIBUTION.meta<ver>):auth($?DISTRIBUTION.meta<auth>):api($?DISTRIBUTION.meta<api>) {

    has Supplier:D $!pipeline .= new;
    has atomicint $!closed = 0;

    submethod TWEAK {
        $reg-lock.protect: { @dispatchers.push: self }
    }

    proto method add(|) {*}

    multi method add(Log::Dispatch::Processor:D $processor --> Nil) {
        await $processor.attach: self;
    }

    multi method add(Log::Dispatch::Processor:U $processor, *%c) {
        self.add: $processor.new(|%c)
    }

    multi method add(Str:D $processor is copy, *%c) {
        unless $processor.contains('::') {
            $processor = 'Log::Dispatch::' ~ $processor;
        }
        require ::($processor);
        self.add: ::($processor), |%c
    }

    method dispatch-msg(Log::Dispatch::Msg:D $msg) {
        $!pipeline.emit: $msg
    }

    method shutdown {
        return if cas($!closed, 0, 1);
        $!pipeline.done;
    }

    method Supply {
        $!pipeline.Supply
    }

    our sub META6 { $?DISTRIBUTION.meta }
}

sub EXPORT {
    Map.new:
        'LOG-LEVEL' => Log::Dispatch::Types::LOG-LEVEL,
}

END {
    $reg-lock.protect: {
        .shutdown for @dispatchers;
    }
}