use v6.d;
unit role Log::Dispatch::Source;
use Log::Dispatch;
use Log::Dispatch::Processor;
use Log::Dispatch::Types;
use Log::Dispatch::X;

also does Log::Dispatch::Processor;

has Str $.LSN = self.log-source-name;
has Bool:D $!with-thread-id = False;
has Log::Dispatch $!dispatcher;

# Starting with 2022.06 release of Rakudo $*STACK-ID is the most reliable way to identify a call stack.
my constant USE-STACK-ID = $*RAKU.compiler.version >= v2022.06;

method log-source-name(--> Nil) {}

method attach($!dispatcher) { Promise.kept }

method use-thread-id(Bool:D $on = True) { $!with-thread-id = $on }

method log(+@msg, *%level) {
    Log::Dispatch::X::NoDispatcher.new(:processor(self)).throw unless $!dispatcher;

    my $level = %level
        .keys
        .map({ LOG-LEVEL::{ $^l.uc } // Log::Dispatch::X::BadLevel.new(level-name => $l).throw })
        .sort({ $^a <=> $^b })
        .head // INFO;

    my Str:D $msg = @msg.map(*.gist).join;

    $!dispatcher.dispatch-msg:
        Log::Dispatch::Msg.new(
            :$level,
            :$msg,
            :source($.LSN),
            |(:thread-id(USE-STACK-ID ?? $*STACK-ID !! $*THREAD.id) if $!with-thread-id));
}