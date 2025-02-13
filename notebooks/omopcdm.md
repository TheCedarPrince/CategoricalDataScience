---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.7
  kernelspec:
    display_name: Julia 1.10.5
    language: julia
    name: julia-1.10
---

# Example of the OMOP CDM Data

## Small Background

> Disclaimer: Section co-written with ChatGPT

The Observational Medical Outcomes Partnership Common Data Model (OMOP CDM) is a database schema and standard designed to facilitate the processing of healthcare data from electronic health records, health information exchanges, and electronic medical records.
Information about the schema is here: https://ohdsi.github.io/CommonDataModel/cdm54.html but the Entity-Relationship Diagram looks like this:

![](./assets/cdm54.png)

Some of the most important tables in the OMOP CDM are as follows:

1. `person`: Contains unique identifiers for individuals, including demographics 
2. `condition_occurrence`: Records diagnoses or health conditions, along with their start and end dates.
3. `procedure_occurrence`: Documents procedures performed on patients, including surgical and diagnostic interventions.
4. `drug_exposure`: Contains information on drug prescriptions, including drug names, dosages, and start/end dates.

Each table is linked through common identifiers (such as `person_id` and various `_occurrence_id` variables), enabling comprehensive analysis. 

## Dependency Set-Up

```julia
using DrWatson
@quickactivate "CompositionalMLStudy"

using DataFrames

import DBInterface:
    execute

import DrWatson:
  datadir

import SQLite:
    DB
```

## Setting Constants

```julia
# OMOP CDM Data Directory
OMOPCDM_DIR = datadir("exp_raw", "OMOPCDM")

# OMOP CDM Example Data 
DATABASE_FILE = "eunomia.sqlite"
```

## Basic Exploration of IPUMS Data

### Creating Connection to SQLite Database

```julia
conn = DB(joinpath(OMOPCDM_DIR, DATABASE_FILE))
```

### Examining Data

List out all tables from the OMOP CDM sample database:

```julia
sql =
    """
    SELECT name AS TABLE_NAME 
    FROM sqlite_master 
    WHERE type = 'table' 
    ORDER BY name;
    """

execute(conn, sql) |> DataFrame
```

Get unique patient IDs from OMOP CDM sample database:

```julia
sql =
    """
    SELECT person_id 
    FROM person;
    """

execute(conn, sql) |> DataFrame
```
