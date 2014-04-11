use strict;
use warnings;
package Dist::Zilla::Plugin::CheckBin;
# ABSTRACT: Require that our distribution has a particular command available
# vim: set ts=8 sw=4 tw=78 et :

use Moose;
with 'Dist::Zilla::Role::InstallTool',
    'Dist::Zilla::Role::PrereqSource',
;
use namespace::autoclean;

sub mvp_multivalue_args { 'command' }

has command => (
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub { [] },
    traits => ['Array'],
    handles => { command => 'elements' },
);

sub register_prereqs {
    my $self = shift;
    $self->zilla->register_prereqs(
        {
          phase => 'configure',
          type  => 'requires',
        },
        'Devel::CheckBin' => '0',
    );
}

# XXX - this should really be a separate phase that runs after InstallTool -
# until then, all we can do is die if we are run too soon
sub setup_installer {
    my $self = shift;

    my @mfpl = grep { $_->name eq 'Makefile.PL' or $_->name eq 'Build.PL' } @{ $self->zilla->files };

    $self->log_fatal('No Makefile.PL or Build.PL was found. [CheckBin] should appear in dist.ini after [MakeMaker] or variant!') unless @mfpl;

    for my $mfpl (@mfpl)
    {
        my $content = "use Devel::CheckBin;\n"
            . join(' ', map { 'check_bin(\'' . $_ . "\');\n" } $self->command)
            . "\n";
        $mfpl->content($content . $mfpl->content);
    }
    return;
}

__PACKAGE__->meta->make_immutable;
__END__

=pod

=head1 SYNOPSIS

In your F<dist.ini>

    [CheckBin]
    command = ls

=head1 DESCRIPTION

L<Dist::Zilla::Plugin::CheckBin> is a L<Dist::Zilla> plugin that modifies the
F<Makefile.PL> or F<Build.PL> in your distribution to contain a
L<Devel::CheckBin> call, that asserts that a particular command is available.
If it is not available, the program exits with a status of zero, which on a
L<CPAN Testers|cpantesters.org> machine will result in a NA result.

=for Pod::Coverage mvp_multivalue_args register_prereqs setup_installer

=head1 CONFIGURATION

=head2 C<command>

Identifies the name of the command that is searched for. Can be used more than once.

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-CheckBin>
(or L<bug-Dist-Zilla-Plugin-CheckBin@rt.cpan.org|mailto:bug-Dist-Zilla-Plugin-CheckBin@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 SEE ALSO

=begin :list

* L<Devel::CheckBin>
* L<Devel::AssertOS> and L<Dist::Zilla::Plugin::AssertOS>

=end :list

=cut
