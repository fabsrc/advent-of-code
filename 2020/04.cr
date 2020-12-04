# https://adventofcode.com/2020/day/4

def parse_passports(input : Array(String)) : Array(Hash(String, String))
  input.map { |i| i.split(/[\s\n]/).map { |e| e.split(":") }.to_h }
end

# Part 1
def get_valid_passport_count(input : Array(String)) : Int
  required_fields = [
    "byr", # Birth Year
    "iyr", # Issue Year
    "eyr", # Expiration Year
    "hgt", # Height
    "hcl", # Hair Color
    "ecl", # Eye Color
    "pid", # Passport ID
  ]
  parse_passports(input).count { |passport|
    required_fields.all? { |field| passport.has_key?(field) }
  }
end

# Part 2
def get_valid_passport_count_with_rules(input : Array(String)) : Int
  parse_passports(input).count { |passport|
    passport.fetch("byr", "").matches?(/(19[2-8][0-9]|199[0-9]|200[0-2])/) &&
      passport.fetch("iyr", "").matches?(/(201[0-9]|2020)/) &&
      passport.fetch("eyr", "").matches?(/(202[0-9]|2030)/) &&
      passport.fetch("hgt", "").matches?(/(1[5-8][0-9]|19[0-3])cm|(59|6[0-9]|7[0-6])in/) &&
      passport.fetch("hcl", "").matches?(/#[a-f0-9]{6}/) &&
      passport.fetch("ecl", "").matches?(/amb|blu|brn|gry|grn|hzl|oth/) &&
      passport.fetch("pid", "").matches?(/^[0-9]{9}$/)
  }
end

raise "Part 1 failed" unless get_valid_passport_count([
                               "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm",
                               "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929",
                               "hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm",
                               "hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in",
                             ]) === 2

raise "Part 2 failed" unless get_valid_passport_count_with_rules([
                               "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926",

                               "iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946",

                               "hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277",

                               "hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007",

                               "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f",

                               "eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm",

                               "hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022",

                               "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719",
                             ]) === 4

if ARGV.size > 0
  input = ARGV[0].split("\n\n")
  puts get_valid_passport_count(input)
  puts get_valid_passport_count_with_rules(input)
end
