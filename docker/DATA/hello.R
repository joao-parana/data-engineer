#! /usr/bin/env Rscript 

# writeLines(readLines(file("stdin")))

f <- file("stdin")
open(f)
while(length(line <- readLines(f, n=1)) > 0)   {
  write(line, stdout())
}
