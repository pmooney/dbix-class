package DBIx::Class::CDBICompat::ColumnCase;

use strict;
use warnings;
use NEXT;

sub _register_column_group {
  my ($class, $group, @cols) = @_;
  return $class->NEXT::ACTUAL::_register_column_group($group => map lc, @cols);
}

sub _register_columns {
  my ($class, @cols) = @_;
  return $class->NEXT::ACTUAL::_register_columns(map lc, @cols);
}

sub has_a {
  my ($class, $col, @rest) = @_;
  $class->NEXT::ACTUAL::has_a(lc($col), @rest);
  $class->mk_group_accessors('has_a' => $col);
  return 1;
}

sub has_many {
  my ($class, $rel, $f_class, $f_key, @rest) = @_;
  return $class->NEXT::ACTUAL::has_many($rel, $f_class, lc($f_key), @rest);
}

sub get_has_a {
  my ($class, $get, @rest) = @_;
  return $class->NEXT::ACTUAL::get_has_a(lc($get), @rest);
}

sub store_has_a {
  my ($class, $set, @rest) = @_;
  return $class->NEXT::ACTUAL::store_has_a(lc($set), @rest);
}

sub set_has_a {
  my ($class, $set, @rest) = @_;
  return $class->NEXT::ACTUAL::set_has_a(lc($set), @rest);
}

sub get_column {
  my ($class, $get, @rest) = @_;
  return $class->NEXT::ACTUAL::get_column(lc($get), @rest);
}

sub set_column {
  my ($class, $set, @rest) = @_;
  return $class->NEXT::ACTUAL::set_column(lc($set), @rest);
}

sub store_column {
  my ($class, $set, @rest) = @_;
  return $class->NEXT::ACTUAL::store_column(lc($set), @rest);
}

sub find_column {
  my ($class, $col) = @_;
  return $class->NEXT::ACTUAL::find_column(lc($col));
}

sub _mk_group_accessors {
  my ($class, $type, $group, @fields) = @_;
  #warn join(', ', map { ref $_ ? (@$_) : ($_) } @fields);
  my @extra;
  foreach (@fields) {
    my ($acc, $field) = ref $_ ? @$_ : ($_, $_);
    #warn "$acc ".lc($acc)." $field";
    next if defined &{"${class}::${acc}"};
    push(@extra, [ lc $acc => $field ]);
  }
  return $class->NEXT::ACTUAL::_mk_group_accessors($type, $group,
                                                     @fields, @extra);
}

sub _cond_key {
  my ($class, $attrs, $key, @rest) = @_;
  return $class->NEXT::ACTUAL::_cond_key($attrs, lc($key), @rest);
}

sub _cond_value {
  my ($class, $attrs, $key, @rest) = @_;
  return $class->NEXT::ACTUAL::_cond_value($attrs, lc($key), @rest);
}

sub new {
  my ($class, $attrs, @rest) = @_;
  my %att;
  $att{lc $_} = $attrs->{$_} for keys %$attrs;
  return $class->NEXT::ACTUAL::new(\%att, @rest);
}

1;
