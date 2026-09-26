use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::NFA qw(new_api response);

sub retry_ok {
        my %arg = @_;

        my $api = new_api(responses => $arg{responses});
        my $got = $api->api_call({method => 'flickr.test.echo', args => {}});

        local $Test::Builder::Level = $Test::Builder::Level + 1;

        subtest $arg{desc} => sub {
                if ($arg{ok}) {
                        ok($got, "api_call returned a document");
                } else {
                        is($got, undef, "api_call returned undef");
                }

                is($api->{api}->calls, $arg{calls}, "made $arg{calls} requests");
                is_deeply($api->sleeps, $arg{sleeps}, "slept as expected");
        };
}

retry_ok(desc      => "plain success",
         responses => [ response(200) ],
         ok        => 1,
         calls     => 1,
         sleeps    => [2]);

retry_ok(desc      => "429 then success, no Retry-After",
         responses => [ response(429), response(200) ],
         ok        => 1,
         calls     => 2,
         sleeps    => [2, 4]);

retry_ok(desc      => "503 twice then success, growing backoff",
         responses => [ response(503), response(503), response(200) ],
         ok        => 1,
         calls     => 3,
         sleeps    => [2, 4, 8]);

retry_ok(desc      => "429 with Retry-After seconds",
         responses => [ response(429, 'Retry-After' => 30), response(200) ],
         ok        => 1,
         calls     => 2,
         sleeps    => [2, 30]);

retry_ok(desc      => "503 with Retry-After in the past",
         responses => [ response(503, 'Retry-After' => 'Thu, 01 Jan 2004 00:00:00 GMT'),
                        response(200) ],
         ok        => 1,
         calls     => 2,
         sleeps    => [2, 0]);

retry_ok(desc      => "other errors are not retried",
         responses => [ response(500) ],
         ok        => 0,
         calls     => 1,
         sleeps    => [2]);

retry_ok(desc      => "give up after ten retries",
         responses => [ map { response(429, 'Retry-After' => 1) } 1 .. 11 ],
         ok        => 0,
         calls     => 11,
         sleeps    => [2, (1) x 10 ]);

done_testing;
