## 0.5.6.9000
#### June 5 2016

**Improvements:**

- `mode = "ld"` is now supported across most analysis functions.
- `sub_job()` works for ranges `ni = c(1:10)`, `nj=c(1:10)`
- Many minor fixes 
- `strata$ld` is hard coded, but this behaviour may be depricated
- `mode = "ld"` works in conjunction with `group = TRUE` and `group_name = character()`

**Issues:**

- Add permutation on same data set
- Timer
- May be bugs as jobs are currently running

**Notes:**

- `strata$k` must be a factor; `strata$ld` must be a double.
- Simultaneously writing to `output` may lead to issues later on when multiple jobs potentially lock it.


## 0.5.5.9000
#### June 3 2016
-----------------

**Improvements:**

- Worked around issues on `attach()` by `@importFrom` all functions used instead of `@import` the whole namespace.
- Continued to pick away at `mode = "ld"`
- Worked around warning on load where `coRge::sub` would overwrite `base::sub`
- Added message `onAttach` with development warning and link for more info.
- Added `SE_mutate()` with minor documentation
- Removed `@export` of `gen2r()` because depricated.

**Issues:**

- LD not working correctly
- `SE_mutate()` might be in the wrong function space becasue `snp_b` is not in the `strata` environment.

**Notes:**

----------------
