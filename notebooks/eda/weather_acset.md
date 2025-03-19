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

## Dependency Set-Up

```julia
using DrWatson
@quickactivate "CompositionalMLStudy"

using ACSets
using Catlab.CategoricalAlgebra
using DataFrames

import DBInterface:
    execute

import DrWatson:
  datadir

import IPUMS:
  load_ipums_extract,
  parse_ddi

import OMOPCDMCohortCreator:
    GenerateDatabaseDetails,
    GenerateTables

import SQLite:
    DB
```

# Data Set-Up

## OMOP CDM Data Directory

```julia
# OMOP CDM Data Directory
OMOPCDM_DIR = datadir("exp_raw", "OMOPCDM")

# OMOP CDM Example Data 
DATABASE_FILE = "eunomia.sqlite"
```

## IPUMS Data Directory

```julia
# IPUMS Data Directory
IPUMS_DIR = datadir("exp_raw", "IPUMS")

# DDI Data Dictionary
DDI_FILE = "cps_00097.xml"

# IPUMS CPS Example Data 
DAT_FILE = "cps_00097.dat"
```

## Load Data

```julia
omop_db_conn = DB(joinpath(OMOPCDM_DIR, DATABASE_FILE))
GenerateDatabaseDetails(:sqlite, "omop");
omop_tables = GenerateTables(omop_db_conn, exported = true);
```

```julia
ddi = parse_ddi(joinpath(IPUMS_DIR, DDI_FILE));
ipums = load_ipums_extract(ddi, joinpath(IPUMS_DIR, DAT_FILE));
```

# ACSet-ifying Data

## OMOP CDM ACSets

### Person Table

```julia
omop_tables[:person].columns
```

```julia
@present SchOMOPCDM(FreeSchema) begin
  (Numerical, Label)::AttrType

  Person::Ob
  person_id::Attr(Person, Numerical) 
  person_source_value::Attr(Person, Label)

  gender_concept_id::Attr(Person, Numerical) 
  gender_source_value::Attr(Person, Label)
  gender_source_concept_id::Attr(Person, Numerical)

  year_of_birth::Attr(Person, Numerical)
  month_of_birth::Attr(Person, Numerical)
  day_of_birth::Attr(Person, Numerical)
  birth_datetime::Attr(Person, Numerical)

  race_concept_id::Attr(Person, Numerical)
  race_source_value::Attr(Person, Label)
  race_source_concept_id::Attr(Person, Numerical)

  ethnicity_concept_id::Attr(Person, Numerical)
  ethnicity_source_value::Attr(Person, Label)
  ethnicity_source_concept_id::Attr(Person, Numerical)

  location_id::Attr(Person, Numerical)
  provider_id::Attr(Person, Numerical)
  care_site_id::Attr(Person, Numerical)

  Death::Ob
  death::Hom(Death, Person)
  # person_id::Attr(Person, Numerical)
  death_date::Attr(Person, Numerical)
  death_datetime::Attr(Person, Numerical)
  death_type_concept_id::Attr(Person, Numerical)
  cause_concept_id::Attr(Person, Numerical)
  cause_source_value::Attr(Person, Label)
  cause_source_concept_id::Attr(Person, Numerical)

  ObservationPeriod::Ob
  observation_period::Hom(ObservationPeriod, Person)
  observation_period_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  observation_period_start_date::Attr(Person, Numerical)
  observation_period_end_date::Attr(Person, Numerical)
  period_type_concept_id::Attr(Person, Numerical)

  VisitOccurrence::Ob
  visit_occurrence::Hom(VisitOccurrence, Person)
  visit_occurrence_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  visit_concept_id::Attr(Person, Numerical)
  visit_start_date::Attr(Person, Numerical)
  visit_start_datetime::Attr(Person, Numerical)
  visit_end_date::Attr(Person, Numerical)
  visit_end_datetime::Attr(Person, Numerical)
  visit_type_concept_id::Attr(Person, Numerical)
  # provider_id::Attr(Person, Numerical)
  # care_site_id::Attr(Person, Numerical)
  visit_source_value::Attr(Person, Label)
  visit_source_concept_id::Attr(Person, Numerical)
  admitted_from_concept_id::Attr(Person, Numerical)
  admitted_from_source_value::Attr(Person, Label)
  discharged_to_concept_id::Attr(Person, Numerical)
  discharged_to_source_value::Attr(Person, Label)
  preceding_visit_occurrence_id::Attr(Person, Numerical)

  ConditionOccurrence::Ob
  condition_occurrence::Hom(ConditionOccurrence, Person)
  condition_occurrence_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  condition_concept_id::Attr(Person, Numerical)
  condition_start_date::Attr(Person, Numerical)
  condition_start_datetime::Attr(Person, Numerical)
  condition_end_date::Attr(Person, Numerical)
  condition_end_datetime::Attr(Person, Numerical)
  condition_type_concept_id::Attr(Person, Numerical)
  condition_status_concept_id::Attr(Person, Numerical)
  stop_reason::Attr(Person, Label)
  # provider_id::Attr(Person, Numerical)
  # visit_occurrence_id::Attr(Person, Numerical)
  # visit_detail_id::Attr(Person, Numerical)
  condition_source_value::Attr(Person, Label)
  condition_source_concept_id::Attr(Person, Numerical)
  condition_status_source_value::Attr(Person, Label)

  DrugExposure::Ob
  drug_exposure::Hom(DrugExposure, Person)
  drug_exposure_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  drug_concept_id::Attr(Person, Numerical)
  drug_exposure_start_date::Attr(Person, Numerical)
  drug_exposure_start_datetime::Attr(Person, Numerical)
  drug_exposure_end_date::Attr(Person, Numerical)
  drug_exposure_end_datetime::Attr(Person, Numerical)
  verbatim_end_date::Attr(Person, Numerical)
  drug_type_concept_id::Attr(Person, Numerical)
  stop_reason::Attr(Person, Label)
  refills::Attr(Person, Numerical)
  quantity::Attr(Person, Numerical)
  days_supply::Attr(Person, Numerical)
  sig::Attr(Person, Label)
  route_concept_id::Attr(Person, Numerical)
  lot_number::Attr(Person, Label)
  # provider_id::Attr(Person, Numerical)
  # visit_occurrence_id::Attr(Person, Numerical)
  # visit_detail_id::Attr(Person, Numerical)
  drug_source_value::Attr(Person, Label)
  drug_source_concept_id::Attr(Person, Numerical)
  route_source_value::Attr(Person, Label)
  dose_unit_source_value::Attr(Person, Numerical)

  ProcedureOccurrence::Ob
  procedure_occurrence::Hom(ProcedureOccurrence, Person)
  procedure_occurrence_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  procedure_concept_id::Attr(Person, Numerical)
  procedure_date::Attr(Person, Numerical)
  procedure_datetime::Attr(Person, Numerical)
  procedure_end_date::Attr(Person, Numerical)
  procedure_end_datetime::Attr(Person, Numerical)
  procedure_type_concept_id::Attr(Person, Numerical)
  modifier_concept_id::Attr(Person, Numerical)
  quantity::Attr(Person, Numerical)
  # provider_id::Attr(Person, Numerical)
  # visit_occurrence_id::Attr(Person, Numerical)
  # visit_detail_id::Attr(Person, Numerical)
  procedure_source_value::Attr(Person, Label)
  procedure_source_concept_id::Attr(Person, Numerical)
  modifier_source_value::Attr(Person, Label)

  DeviceExposure::Ob
  device_occurrence::Hom(DeviceExposure, Person)
  device_exposure_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  device_concept_id::Attr(Person, Numerical)
  device_exposure_start_date::Attr(Person, Numerical)
  device_exposure_start_datetime::Attr(Person, Numerical)
  device_exposure_end_date::Attr(Person, Numerical)
  device_exposure_end_datetime::Attr(Person, Numerical)
  device_type_concept_id::Attr(Person, Numerical)
  unique_device_id::Attr(Person, Label)
  production_id::Attr(Person, Label)
  quantity::Attr(Person, Numerical)
  # provider_id::Attr(Person, Numerical)
  # visit_occurrence_id::Attr(Person, Numerical)
  # visit_detail_id::Attr(Person, Numerical)
  device_source_value::Attr(Person, Label)
  device_source_concept_id::Attr(Person, Numerical)
  unit_concept_id::Attr(Person, Numerical)
  unit_source_value::Attr(Person, Label)
  unit_source_concept_id::Attr(Person, Numerical)

  Measurement::Ob
  measurement::Hom(Measurement, Person)
  measurement_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  measurement_concept_id::Attr(Person, Numerical)
  measurement_date::Attr(Person, Numerical)
  measurement_datetime::Attr(Person, Numerical)
  measurement_time::Attr(Person, Label)
  measurement_type_concept_id::Attr(Person, Numerical)
  operator_concept_id::Attr(Person, Numerical)
  value_as_number::Attr(Person, Numerical)
  value_as_concept_id::Attr(Person, Numerical)
  unit_concept_id::Attr(Person, Numerical)
  range_low::Attr(Person, Numerical)
  range_high::Attr(Person, Numerical)
  # provider_id::Attr(Person, Numerical)
  # visit_occurrence_id::Attr(Person, Numerical)
  # visit_detail_id::Attr(Person, Numerical)
  measurement_source_value::Attr(Person, Label)
  measurement_source_concept_id::Attr(Person, Numerical)
  unit_source_value::Attr(Person, Label)
  unit_source_concept_id::Attr(Person, Numerical)
  value_source_value::Attr(Person, Label)
  measurement_event_id::Attr(Person, Numerical)
  meas_event_field_concept_id::Attr(Person, Numerical)

  Observation::Ob
  observation::Hom(Observation, Person)
  observation_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  observation_concept_id::Attr(Person, Numerical)
  observation_date::Attr(Person, Numerical)
  observation_datetime::Attr(Person, Numerical)
  observation_type_concept_id::Attr(Person, Numerical)
  value_as_number::Attr(Person, Numerical)
  value_as_string::Attr(Person, Label)
  value_as_concept_id::Attr(Person, Numerical)
  qualifier_concept_id::Attr(Person, Numerical)
  unit_concept_id::Attr(Person, Numerical)
  # provider_id::Attr(Person, Numerical)
  # visit_occurrence_id::Attr(Person, Numerical)
  # visit_detail_id::Attr(Person, Numerical)
  observation_source_value::Attr(Person, Label)
  observation_source_concept_id::Attr(Person, Numerical)
  unit_source_value::Attr(Person, Label)
  qualifier_source_value::Attr(Person, Label)
  value_source_value::Attr(Person, Label)
  observation_event_id::Attr(Person, Numerical)
  obs_event_field_concept_id::Attr(Person, Numerical)

  Note::Ob
  note::Hom(Note, Person)
  note_id::Attr(Person, Numerical)
  person_id::Attr(Person, Numerical)
  note_date::Attr(Person, Numerical)
  note_datetime::Attr(Person, Numerical)
  note_type_concept_id::Attr(Person, Numerical)
  note_class_concept_id::Attr(Person, Numerical)
  note_title::Attr(Person, Label)
  note_text::Attr(Person, Label)
  encoding_concept_id::Attr(Person, Numerical)
  language_concept_id::Attr(Person, Numerical)
  provider_id::Attr(Person, Numerical)
  visit_occurrence_id::Attr(Person, Numerical)
  visit_detail_id::Attr(Person, Numerical)
  note_source_value::Attr(Person, Label)
  note_event_id::Attr(Person, Numerical)
  note_event_field_concept_id::Attr(Person, Numerical)

  Episode::Ob
  episode::Hom(Episode, Person)
  episode_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  episode_concept_id::Attr(Person, Numerical)
  episode_start_date::Attr(Person, Numerical)
  episode_start_datetime::Attr(Person, Numerical)
  episode_end_date::Attr(Person, Numerical)
  episode_end_datetime::Attr(Person, Numerical)
  episode_parent_id::Attr(Person, Numerical)
  episode_number::Attr(Person, Numerical)
  episode_object_concept_id::Attr(Person, Numerical)
  episode_type_concept_id::Attr(Person, Numerical)
  episode_source_value::Attr(Person, Label)
  episode_source_concept_id::Attr(Person, Numerical)

  Specimen::Ob
  specimen::Hom(Specimen, Person)
  specimen_id::Attr(Person, Numerical)
  # person_id::Attr(Person, Numerical)
  specimen_concept_id::Attr(Person, Numerical)
  specimen_type_concept_id::Attr(Person, Numerical)
  specimen_date::Attr(Person, Numerical)
  specimen_datetime::Attr(Person, Numerical)
  quantity::Attr(Person, Numerical)
  unit_concept_id::Attr(Person, Numerical)
  anatomic_site_concept_id::Attr(Person, Numerical)
  disease_status_concept_id::Attr(Person, Numerical)
  specimen_source_id::Attr(Person, Label)
  specimen_source_value::Attr(Person, Label)
  unit_source_value::Attr(Person, Label)
  anatomic_site_source_value::Attr(Person, Label)
  disease_status_source_value::Attr(Person, Label)

  VisitDetail::Ob
  visit_detail::Hom(VisitDetail, Person)
  visit_detail_id::Attr(Person, Numerical)
  person_id::Attr(Person, Numerical)
  visit_detail_concept_id::Attr(Person, Numerical)
  visit_detail_start_date::Attr(Person, Numerical)
  visit_detail_start_datetime::Attr(Person, Numerical)
  visit_detail_end_date::Attr(Person, Numerical)
  visit_detail_end_datetime::Attr(Person, Numerical)
  visit_detail_type_concept_id::Attr(Person, Numerical)
  provider_id::Attr(Person, Numerical)
  care_site_id::Attr(Person, Numerical)
  visit_detail_source_value::Attr(Person, Label)
  visit_detail_source_concept_id::Attr(Person, Numerical)
  admitted_from_concept_id::Attr(Person, Numerical)
  admitted_from_source_value::Attr(Person, Label)
  discharged_to_source_value::Attr(Person, Label)
  discharged_to_concept_id::Attr(Person, Numerical)
  preceding_visit_detail_id::Attr(Person, Numerical)
  parent_visit_detail_id::Attr(Person, Numerical)
  visit_occurrence_id::Attr(Person, Numerical)

end
```

```julia
@acset_type OMOPCDMData(SchOMOPCDM, 
    index = [:death, :observation_period],
    unique_index = [:person_id]
)
```

```julia
person_df = execute(omop_db_conn, "SELECT * FROM person;") |> DataFrame
death_df = execute(omop_db_conn, "SELECT * FROM death;") |> DataFrame
observation_period_df = execute(omop_db_conn, "SELECT * FROM observation_period;") |> DataFrame
omopcdm = OMOPCDMData{Any, Any}()

add_parts!(omopcdm, :Person, nrow(person_df), person_id = person_df.person_id, person_source_value = person_df.person_source_value, gender_concept_id = person_df.gender_concept_id, gender_source_value = person_df.gender_source_value, gender_source_concept_id = person_df.gender_source_concept_id, year_of_birth = person_df.year_of_birth, month_of_birth = person_df.month_of_birth, day_of_birth = person_df.day_of_birth, birth_datetime = person_df.birth_datetime, race_concept_id = person_df.race_concept_id, race_source_value = person_df.race_source_value, race_source_concept_id = person_df.race_source_concept_id, ethnicity_concept_id = person_df.ethnicity_concept_id, ethnicity_source_value = person_df.ethnicity_source_value, ethnicity_source_concept_id = person_df.ethnicity_source_concept_id, location_id = person_df.location_id, provider_id = person_df.provider_id, care_site_id = person_df.care_site_id)
add_parts!(omopcdm, :Death, nrow(death_df), death_date = death_df.death_date, death_datetime = death_df.death_datetime, death_type_concept_id = death_df.death_type_concept_id, cause_concept_id = death_df.cause_concept_id, cause_source_value = death_df.cause_source_value, cause_source_concept_id = death_df.cause_source_concept_id)
add_parts!(omopcdm, :ObservationPeriod, nrow(observation_period_df), observation_period_id = observation_period_df.observation_period_id, observation_period_start_date = observation_period_df.observation_period_start_date, observation_period_end_date = observation_period_df.observation_period_end_date, period_type_concept_id = observation_period_df.period_type_concept_id)
```

```julia
omopcdm
```
