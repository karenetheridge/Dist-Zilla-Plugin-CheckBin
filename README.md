# NAME

Dist::Zilla::Plugin::CheckBin - Require that our distribution has a particular command available

# VERSION

version 0.001

# SYNOPSIS

In your `dist.ini`

    [CheckBin]
    command = ls

# DESCRIPTION

[Dist::Zilla::Plugin::CheckBin](https://metacpan.org/pod/Dist::Zilla::Plugin::CheckBin) is a [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugin that modifies the
`Makefile.PL` or `Build.PL` in your distribution to contain a
[Devel::CheckBin](https://metacpan.org/pod/Devel::CheckBin) call, that asserts that a particular command is available.
If it is not available, the program exits with a status of zero, which on a
[CPAN Testers](https://metacpan.org/pod/cpantesters.org) machine will result in a NA result.

# CONFIGURATION

## `command`

Identifies the name of the command that is searched for. Can be used more than once.

# SUPPORT

Bugs may be submitted through [the RT bug tracker](https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-CheckBin)
(or [bug-Dist-Zilla-Plugin-CheckBin@rt.cpan.org](mailto:bug-Dist-Zilla-Plugin-CheckBin@rt.cpan.org)).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# SEE ALSO

- [Devel::CheckBin](https://metacpan.org/pod/Devel::CheckBin)
- [Devel::AssertOS](https://metacpan.org/pod/Devel::AssertOS) and [Dist::Zilla::Plugin::AssertOS](https://metacpan.org/pod/Dist::Zilla::Plugin::AssertOS)

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
