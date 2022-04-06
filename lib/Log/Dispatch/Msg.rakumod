unit class Log::Dispatch::Msg;
use Log::Dispatch::Types;

has DateTime:D $.timestamp = DateTime.now;
has LOG-LEVEL:D $.level = INFO;
has Str $.source;
has Str:D $.msg is required;
has Int $.thread-id;

method fmt-level { $.level.key.fmt: '%9s' }

method fmt-thread-id { $.thread-id.defined ?? $.thread-id.fmt('%4d') !! "    " }

method fmt-timestamp {
    my $tz;
    .yyyy-mm-dd ~ " "
        ~ .hh-mm-ss
        ~ ( (($tz = .timezone) > 0 ?? '+' !! '-')
        ~ ($tz div 3600).abs.fmt('%02d')
        ~ (($tz % 3600) div 60).fmt('%02d'))
    with $.timestamp
}

method fmt-lines(--> Seq:D) {
    my $prefix = self.fmt-timestamp ~ " [" ~ self.fmt-level ~ "]";
    my @src = |($_ with $.source), |(self.fmt-thread-id with $.thread-id);
    my $src = (@src ?? " [" ~ @src.join(":") ~ "]" !! "");

    $.msg
        .split(/\n/)
        .map({ $prefix ~ $src ~ " " ~ $^line })
}