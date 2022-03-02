use v6.d;
unit role Log::Dispatch::Source;
use Log::Dispatch;
use Log::Dispatch::Processor;
use Log::Dispatch::Types;
use Log::Dispatch::X;

also does Log::Dispatch::Processor;

has Str $.name = self.log-source-name;
has Log::Dispatch $!dispatcher;

method log-source-name(--> Nil) {}

method attach($!dispatcher) { Promise.kept }

method log(+@msg, *%level) {
    Log::Dispatch::X::NoDispatcher.new(:processor(self)).throw unless $!dispatcher;

    my $level = %level
        .keys
        .map({ LOG-LEVEL::{ $^l.uc } // Log::Dispatch::X::BadLevel.new(level-name => $l).throw })
        .sort({ $^a <=> $^b })
        .head // INFO;

    $!dispatcher.dispatch-msg: Log::Dispatch::Msg.new(:$level, :@msg, :source($.name));
}