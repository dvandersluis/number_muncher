module NumberMuncher
  module Unicode
    MAPPING = {
      '½' => 1/2r,
      '⅓' => 1/3r,
      '⅔' => 2/3r,
      '¼' => 1/4r,
      '¾' => 3/4r,
      '⅕' => 1/5r,
      '⅖' => 2/5r,
      '⅗' => 3/5r,
      '⅘' => 4/5r,
      '⅙' => 1/6r,
      '⅚' => 5/6r,
      '⅐' => 1/7r,
      '⅛' => 1/8r,
      '⅜' => 3/8r,
      '⅝' => 5/8r,
      '⅞' => 7/8r,
      '⅑' => 1/9r,
      '⅒' => 1/10r
    }.freeze

    VALUES = MAPPING.keys
    REGEX = Regexp.union(VALUES).freeze
  end
end
