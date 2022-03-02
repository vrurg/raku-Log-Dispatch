use v6.d;
unit module Log::Dispatch::X;

our role Base is Exception { }

class BadLevel does Base {
    has Str:D $.level-name is required;
    method message { "Unknown log level '$.level-name'" }
}

class NoDispatcher does Base {
    has $.processor is required;
    method message { "Processor '" ~ $.processor.^shortname ~ "' is not attached to a dispatcher yet" }
}

class LogClosed does Base {
    has $.processor is required;
    method message {
        "Cannot log into a closed destination of type '" ~ $.processor.^name ~ "'"
    }
}