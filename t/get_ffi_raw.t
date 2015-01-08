use strict;
use warnings;
use 5.010;
use FindBin ();
use lib $FindBin::Bin;
use testlib;
use Test::More tests => 4;
use FFI::TinyCC;
use FFI::Raw;

my $tcc = FFI::TinyCC->new;

eval { $tcc->compile_string(q{int foo(int in1) { return in1; }}) };
is $@, '', 'tcc.compile_string';

my $foo = eval { 
  local $FFI::TinyCC::_get_ffi_raw_deprecation = 0;
  $tcc->get_ffi_raw('foo', FFI::Raw::int, FFI::Raw::int) 
};
is $@, '', 'tcc.get_ffi_raw';

isa_ok $foo, 'FFI::Raw';

is eval { $foo->call(42) }, 42, 'foo.call = 42';
