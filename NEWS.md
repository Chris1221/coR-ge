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
