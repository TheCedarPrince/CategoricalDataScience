---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.7
  kernelspec:
    display_name: Julia 1.10.4
    language: julia
    name: julia-1.10
---

# Example Usage of IPUMS Data

## Small Background

> Disclaimer: Section co-written with ChatGPT

**IPUMS** (Integrated Public Use Microdata Series) is a project that harmonizes and centralizes survey data from across the globe to allow for easier comparison and analysis.
The data is free to access but an account must be made per each individual project imprint of **IPUMS** (link: https://www.ipums.org)

The **IPUMS CPS** dataset is derived from the U.S. Current Population Survey (CPS), which is a monthly survey conducted by the U.S. Census Bureau and the Bureau of Labor Statistics (BLS) (link here: https://cps.ipums.org/cps/). 
The CPS collects data on employment, unemployment, earnings, demographics, and other social and economic factors. 
The most important variables within the CPS are:

1. **Household-Level Data**: Contains information about the composition of households, housing characteristics, and household-level variables such as total income.
2. **Person-Level Data**: Focuses on individual respondents, providing detailed information on demographic factors such as age, race, gender, and educational attainment.
3. **Labor Force Data**: Records employment status, occupation, hours worked, and wage data for individuals. 

## Dependency Set-Up

```julia
using DrWatson
@quickactivate "CompositionalMLStudy"

using DataFrames

import DrWatson:
  datadir

import IPUMS:
  load_ipums_extract,
  parse_ddi
```

## Setting Constants

```julia
# IPUMS Data Directory
IPUMS_DIR = datadir("exp_raw", "IPUMS")

#=

  IPUMS DDI and DAT file to be used.
  When one file name is changed, the 
  other should be updated as well.

=#

# DDI Data Dictionary
DDI_FILE = "cps_00097.xml"

# IPUMS CPS Example Data 
DAT_FILE = "cps_00097.dat"
```

## Basic Exploration of IPUMS Data

### Loading Data

Loading data dictionary (xml) and [IPUMS International](https://international.ipums.org/international/index.shtml) data file (dat):

```julia
ddi = parse_ddi(joinpath(IPUMS_DIR, DDI_FILE));
df = load_ipums_extract(ddi, joinpath(IPUMS_DIR, DAT_FILE));
first(df, 5)
```

### Examining Metadata

By `DataFrame`:

```julia
meta_info = metadata(df)
for md in keys(meta_info)
  println("$(md):\n----------------\n\n $(meta_info[md])\n\n")
end
```

By each column of the `DataFrame`:

```julia
for colname in names(df)
  println("$(colname):\n----------------\n\n $(colmetadata(df, colname, "description"))\n\n")
end
```
