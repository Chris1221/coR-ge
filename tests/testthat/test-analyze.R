library(coRge)

# I should definitely fix this but for the moment
# Actual name is genEx
data(gen_toy)

# Actual name is exampleSamp
data(summary_toy)

expect_equal(analyze(i = 3, j = 3, local = TRUE, gen = genEx, summary = exampleSamp, mode = "ld", output = "/dev/null", nc = 5), 0)

