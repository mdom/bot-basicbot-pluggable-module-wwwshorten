use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Bot::BasicBot::Pluggable::Module::WWW::Shorten',
    license             => 'perl',
    dist_author         => q{Mario Domgoergen <mdom@cpan.org>},
    dist_version_from   => 'lib/Bot/BasicBot/Pluggable/Module/WWW/Shorten.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Bot-BasicBot-Pluggable-Module-WWW-Shorten-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
