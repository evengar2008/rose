package Rose::HTML::Form::Field::Integer;

use strict;

use Rose::HTML::Form::Field::Text;
our @ISA = qw(Rose::HTML::Form::Field::Text);

our $VERSION = '0.52';

use Rose::Object::MakeMethods::Generic
(
  scalar => [ qw(min max) ],
);

__PACKAGE__->default_html_attr_value(size  => 6);

sub validate
{
  my($self) = shift;

  my $ok = $self->SUPER::validate(@_);
  return $ok  unless($ok);

  my $value = $self->internal_value;
  return 1  unless(length $value);

  my $min = $self->min;
  my $max = $self->max;

  my $name = $self->label || $self->name;

  unless($value =~ /^-?\d+$/)
  {
    $self->error("$name must be a" . (defined $min && $min >= 0 ? 
                 ' positive ' : 'n ') . 'integer');
    return 0;
  }

  if(defined $min && $value < $min)
  {
    if($min == 0)
    {
      $self->error("$name must be a positive integer");
    }
    else
    {
      $self->error("$name must be greater than " . ($min - 1));
    }
    return 0;
  }

  if(defined $max && $value > $max)
  {
    $self->error("$name must be less than or equal to $max");
    return 0;
  }

  return 1;
}

1;

__END__

=head1 NAME

Rose::HTML::Form::Field::Integer - Text field that only accepts integer values.

=head1 SYNOPSIS

    $field =
      Rose::HTML::Form::Field::Integer->new(
        label     => 'Count', 
        name      => 'count',
        maxlength => 6);

    $field->input_value('abc');
    $field->validate; # false

    $field->input_value(123);
    $field->validate; # true

    # Set minimum and maximum values
    $field->min(2);
    $field->max(100);

    $field->input_value(123);
    $field->validate; # false

    $field->input_value(1);
    $field->validate; # false

    $field->input_value(5);
    $field->validate; # true

    print $field->html;
    ...

=head1 DESCRIPTION

L<Rose::HTML::Form::Field::Integer> is a subclass of L<Rose::HTML::Form::Field::Text> only accepts integer values.  It overrides the L<validate()|Rose::HTML::Form::Field/validate> method of its parent class, returning true if the L<internal_value()|Rose::HTML::Form::Field/internal_value> is a valid integer, or setting an error message and returning false otherwise.

Use the L<min|/min> and :<max|/max> attributes to control whether the range of valid values.

=head1 OBJECT METHODS

=item B<max [INT]>

Get or set a the maximum acceptable value.  If the field's L<internal_value()|Rose::HTML::Form::Field/internal_value> is B<greater than> this value, then the L<validate()|Rose::HTML::Form::Field/validate> method will return false.  If undefined, then no limit on the maximum value is enforced.

=item B<min [INT]>

Get or set a the minimum acceptable value.  If the field's L<internal_value()|Rose::HTML::Form::Field/internal_value> is B<less than> this value, then the L<validate()|Rose::HTML::Form::Field/validate> method will return false.  If undefined, then no limit on the minimum value is enforced.

=back

=head1 AUTHOR

John C. Siracusa (siracusa@mindspring.com)

=head1 COPYRIGHT

Copyright (c) 2006 by John C. Siracusa.  All rights reserved.  This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
