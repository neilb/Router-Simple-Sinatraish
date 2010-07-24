use strict;
use warnings;
use Test::More tests => 7;

{
    package MyApp;
    use Router::Simple::Sinatraish;
    get '/' => sub {
        return "GET TOP"
    };
    post '/' => sub {
        return "POST TOP"
    };
    any '/foo' => sub {
        return "ANY FOO"
    };
}

my $r1 = MyApp->router;
my $r2 = MyApp->router;
is "$r1", "$r2";

{
    my $route = MyApp->router->match( +{ REQUEST_METHOD => 'GET', PATH_INFO => '/foo' } );
    ok $route, '/foo';
    is $route->{code}->(), "ANY FOO";
}

{
    my $route = MyApp->router->match( +{ REQUEST_METHOD => 'GET', PATH_INFO => '/' } );
    ok $route, 'GET /';
    is $route->{code}->(), "GET TOP";
}

{
    my $route = MyApp->router->match( +{ REQUEST_METHOD => 'POST', PATH_INFO => '/' } );
    ok $route, 'POST /';
    is $route->{code}->(), "POST TOP";
}

