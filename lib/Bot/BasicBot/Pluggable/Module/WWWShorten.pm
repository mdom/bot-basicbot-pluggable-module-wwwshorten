package Bot::BasicBot::Pluggable::Module::WWWShorten;

use warnings;
use strict;
use parent 'Bot::BasicBot::Pluggable::Module';
use URI::Find::Rule;
use Try::Tiny;
use Module::Load;
use HTML::HeadParser;
use LWP::UserAgent;

our $VERSION = '0.01';

sub init {
	my $self = shift;
	$self->config({
		service => 'TinyURL',
	});
}

sub admin {
	my ($self,$message) = @_;

	my $body = $message->{body};
	return if ! $body;

	my @uris = map { $_->[1] } URI::Find::Rule->http->in($body);
	return if ! @uris;

	my $service = $self->get('service');
	my $module  = "WWW::Shorten::$service";
	try { load $module } catch { die "Can't load service $service: $@" };

	$module->import('makeashorterlink');
	for my $uri (@uris) {
		my ($short_link,$title);
		try {
			$short_link = makeashorterlink($uri);
			
			my $ua = LWP::UserAgent->new(
				env_proxy => 1,
				timeout => 30,
			);

			my $response = $ua->get($uri);
			die unless $response->is_success;
			my $html = $response->content;

			my $parser = HTML::HeadParser->new;
			1 while $parser->parse($html);
			$title = $parser->header('Title');
			
		} catch {
			die "Can't generate short link: $_";
		};
		
		my $reply = $short_link;
		$reply .= " [ $title ]" if $title;
		$self->reply($message,$reply);
	}
}

1; # End of Bot::BasicBot::Pluggable::Module::WWW::Shorten

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::WWW::Shorten - The great new Bot::BasicBot::Pluggable::Module::WWW::Shorten!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Bot::BasicBot::Pluggable::Module::WWW::Shorten;
    my $foo = Bot::BasicBot::Pluggable::Module::WWW::Shorten->new();

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=head2 function2

=head1 AUTHOR

Mario Domgoergen, C<< <mdom at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-bot-basicbot-pluggable-module-www-shorten at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Bot-BasicBot-Pluggable-Module-WWW-Shorten>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Bot::BasicBot::Pluggable::Module::WWW::Shorten


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Bot-BasicBot-Pluggable-Module-WWW-Shorten>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Bot-BasicBot-Pluggable-Module-WWW-Shorten>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Bot-BasicBot-Pluggable-Module-WWW-Shorten>

=item * Search CPAN

L<http://search.cpan.org/dist/Bot-BasicBot-Pluggable-Module-WWW-Shorten/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Mario Domgoergen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
