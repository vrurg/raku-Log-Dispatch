unit class Log::Dispatch::Msg;
use Log::Dispatch::Types;

has Instant:D $.timestamp = now;
has LOG-LEVEL:D $.level = INFO;
has Str $.source;
has Str:D $.msg is required;

method fmt-level { $.level.key.fmt: '%9s' }

method fmt-timestamp { .yyyy-mm-dd ~ " " ~ .hh-mm-ss with $.timestamp.DateTime }

method fmt-lines(--> Seq:D) {
    $.msg
        .split(/\n/)
        .map({ self.fmt-timestamp ~ " [" ~ self.fmt-level ~ "]" ~ (" [" ~ $_ ~ "]" with $.source) ~ " " ~ $^line })
}