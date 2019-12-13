# NumberMuncher

[![Build Status](https://travis-ci.org/dvandersluis/fractions.svg?branch=master)](https://travis-ci.org/dvandersluis/fractions)
[![Gem Version](https://badge.fury.io/rb/number_muncher.svg)](https://badge.fury.io/rb/number_muncher)

Parses strings into numbers, including integers, decimals, and fractions (including unicode fraction glyphs like `⅐`). 

<p align="center">
  <img src="assets/muncher.jpg" width="15%" height="15%">
  <br/>
  <sup align="center">
    A <a href="https://en.wikipedia.org/wiki/Munchers#Number_Munchers">Number Muncher</a>
  </sup>
</p>

## Usage

### Formats

`NumberMuncher` accepts the following formats (with an optional leading `-`):

* Integers (with or without separators): `1`, `-1`, `5,394`, `9592`, etc.
* Decimals (with or without separators): `3.5`, `-7.4`, `9,104.94`, etc.
* Fractions: `3/5`, `-19/20`, `¾`, etc. (see [`unicode.rb`](lib/number_muncher/unicode.rb) for a full list of supported Unicode fraction glyphs).
* Mixed fractions (with or without separators): `3 3/4`, `1-1/3`, `-1⅔`, `1,234 ⅚`, etc.

Other inputs, including invalid fractions (eg. `1/0`), are considered invalid and will raise `NumberMuncher::InvalidNumber`.

### Parsing

Parsing a numeric string for a single `Rational` (which can then have `to_i`, `to_f`, etc. called on it as per your needs):

```ruby
NumberMuncher.parse('4 1/2') #=> 9/2r

# or equivalent:
NumberMuncher::Numeric.new('4 1/2') 
```

If the input string contains multiple numbers (other than mixed fractions), `NumberMuncher::InvalidParseExpression` will be raised.

### Scanning

Returns all the numbers in a string, as `Rational`s.

```ruby
NumberMuncher.scan('Cook at 375° for 10 minutes, flip and cook for another 5.5 minutes')
# => [375r, 10r, 11/2r]
```

### Formatting

Returns a fraction string for a given numeric value.

```ruby
NumberMuncher.to_fraction(1/4r) #=> "¼"
NumberMuncher.to_fraction(9.625) #=> "9⅝"

# Without using unicode glyphs:
NumberMuncher.to_fraction(1/4r, unicode: false) #=> "1/4"
NumberMuncher.to_fraction(9.625, unicode: false) #=> "9 5/8"

# Rounding:
NumberMuncher.to_fraction(3/7r, round_to: 1/4r) #=> "½"

# Rationalizing (adjust the fraction precision, default = 0.001):
NumberMuncher.to_fraction(Math::PI) #=> "3 9/64"
NumberMuncher.to_fraction(Math::PI, factor: 0.1) #=> "3⅕"
NumberMuncher.to_fraction(Math::PI, factor: 0.0000000000000001) #=> "3 39854788871587/281474976710656"  
```

`to_fraction` can also be called as an instance method. Note that this method does not take a `round_to` argument, but you can chain `round` before calling `to_fraction`:

```ruby
NumberMuncher.parse('3.456').to_fraction #=> "3 21/46" 
NumberMuncher.parse('3.456').round(0.1).to_fraction #=> "3½"
NumberMuncher.parse('3.456').round(0.1).to_fraction(unicode: false) #=> "3 1/2"
```

## Installation

`NumberMuncher` requires ruby >= 2.3.

Add this line to your application's Gemfile:

```ruby
gem 'number_muncher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install number_muncher

## Configuration

Separators for thousands and decimals can be configured. Default values are shown below:

```ruby
NumberMuncher.thousands_separator = ','
NumberMuncher.decimal_separator = '.'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvandersluis/number_muncher.
