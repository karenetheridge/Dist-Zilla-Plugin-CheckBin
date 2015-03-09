use strict;
use warnings;
package Dist::Zilla::Plugin::CheckBin;
# ABSTRACT: Require that our distribution has a particular command available
# KEYWORDS: distribution installation require binary program executable
# vim: set ts=8 sts=4 sw=4 tw=78 et :

our $VERSION = '0.008';

use Moose;
with
    'Dist::Zilla::Role::FileMunger',
    'Dist::Zilla::Role::InstallTool',
    'Dist::Zilla::Role::PrereqSource',
;
use Scalar::Util 'blessed';
use namespace::autoclean;

sub mvp_multivalue_args { 'command' }

has command => (
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub { [] },
    traits => ['Array'],
    handles => { command => 'sort' },   # sorted elements
);

around dump_config => sub
{
    my ($orig, $self) = @_;
    my $config = $self->$orig;

    $config->{+__PACKAGE__} = {
        command => [ $self->command ],
    };

    return $config;
};

sub register_prereqs
{
    my $self = shift;
    $self->zilla->register_prereqs(
        {
          phase => 'configure',
          type  => 'requires',
        },
        'Devel::CheckBin' => '0',
    );
}

my %files;
sub munge_files
{
    my $self = shift;

    my @mfpl = grep { $_->name eq 'Makefile.PL' or $_->name eq 'Build.PL' } @{ $self->zilla->files };
    for my $mfpl (@mfpl)
    {
        $self->log_debug('munging ' . $mfpl->name . ' in file gatherer phase');
        $files{$mfpl->name} = $mfpl;
        $self->_munge_file($mfpl);
    }
    return;
}

# XXX - this should really be a separate phase that runs after InstallTool -
# until then, all we can do is die if we are run too soon
sub setup_installer
{
    my $self = shift;

    my @mfpl = grep { $_->name eq 'Makefile.PL' or $_->name eq 'Build.PL' } @{ $self->zilla->files };

    $self->log_fatal('No Makefile.PL or Build.PL was found. [CheckBin] should appear in dist.ini after [MakeMaker] or variant!') unless @mfpl;

    for my $mfpl (@mfpl)
    {
        next if exists $files{$mfpl->name};
        $self->log_debug('munging ' . $mfpl->name . ' in setup_installer phase');
        $self->_munge_file($mfpl);
    }
    return;
}

sub _munge_file
{
    my ($self, $file) = @_;

    my $orig_content = $file->content;
    $self->log_fatal('could not find position in ' . $file->name . ' to modify!')
        if not $orig_content =~ m/use strict;\nuse warnings;\n\n/g;

    my $pos = pos($orig_content);

    my $content =
        '# inserted by ' . blessed($self) . ' ' . $self->VERSION . "\n"
        . "use Devel::CheckBin;\n"
        . join('', map { 'check_bin(\'' . $_ . "\');\n" } $self->command)
        . "\n";

    $file->content(
        substr($orig_content, 0, $pos)
        . $content
        . substr($orig_content, $pos)
    );
}

__PACKAGE__->meta->make_immutable;
__END__

=pod

=head1 SYNOPSIS

In your F<dist.ini>:

    [CheckBin]
    command = ls

=head1 DESCRIPTION

L<Dist::Zilla::Plugin::CheckBin> is a L<Dist::Zilla> plugin that modifies the
F<Makefile.PL> or F<Build.PL> in your distribution to contain a
L<Devel::CheckBin> call, that asserts that a particular command is available.
If it is not available, the program exits with a status of zero, which on a
L<CPAN Testers|cpantesters.org> machine will result in a NA result.

=for Pod::Coverage mvp_multivalue_args register_prereqs munge_files setup_installer

=head1 CONFIGURATION OPTIONS

=head2 C<command>

Identifies the name of the command that is searched for. Can be used more than once.

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-CheckBin>
(or L<bug-Dist-Zilla-Plugin-CheckBin@rt.cpan.org|mailto:bug-Dist-Zilla-Plugin-CheckBin@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 SEE ALSO

=for :list
* L<Devel::CheckBin>
* L<Devel::AssertOS> and L<Dist::Zilla::Plugin::AssertOS>
* L<Devel::CheckLib> and L<Dist::Zilla::Plugin::CheckLib>

=cut
